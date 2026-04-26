import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

import '../../../services/hf_ai_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadNotesScreen extends StatefulWidget {
  const UploadNotesScreen({super.key});

  @override
  State<UploadNotesScreen> createState() =>
      _UploadNotesScreenState();
}

class _UploadNotesScreenState
    extends State<UploadNotesScreen> {
  final HuggingFaceService _aiService =
  HuggingFaceService();

  String extractedText = "";
  String summary = "";
  String fileName = "";

  bool isLoading = false;
  bool isSaving = false;

  /////////////////////////////////////////////////////////////

  Future<void> pickFile() async {
    try {
      FilePickerResult? result =
      await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'pdf'],
        withData: true,
      );

      if (result != null) {
        final file =
            result.files.single;

        fileName = file.name;

        if (file.bytes != null) {
          extractedText =
              utf8.decode(file.bytes!);
        }

        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Failed to pick file"),
        ),
      );
    }
  }

  /////////////////////////////////////////////////////////////

  Future<void> generateSummary() async {
    if (extractedText.isEmpty)
      return;

    setState(() {
      isLoading = true;
    });

    try {
      summary =
      await _aiService.summarizeText(
        extractedText,
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Failed to generate summary"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  /////////////////////////////////////////////////////////////

  Future<void> saveSummary() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (summary.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("No summary to save"),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('summaries')
          .add({
        "title": fileName,
        "summary": summary,
        "createdAt":
        FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Summary saved successfully"),
        ),
      );

      summary = "";
      extractedText = "";
      fileName = "";
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Failed to save summary"),
        ),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  /////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Upload Notes"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.all(16),
          child: Column(
            children: [

              /////////////////////////////////////////////
              /// STEP TITLE

              const Text(
                "Upload your notes and generate a summary",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              /////////////////////////////////////////////
              /// UPLOAD BUTTON

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(
                      Icons.upload_file),
                  label: const Text(
                    "Upload TXT or PDF",
                  ),
                  onPressed: pickFile,
                ),
              ),

              const SizedBox(height: 20),

              /////////////////////////////////////////////
              /// FILE CARD

              if (fileName.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(
                      16),
                  decoration:
                  BoxDecoration(
                    color: Colors
                        .green.shade50,
                    borderRadius:
                    BorderRadius
                        .circular(12),
                    border: Border.all(
                      color: Colors.green,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      const SizedBox(
                          width: 10),
                      Expanded(
                        child: Text(
                          fileName,
                          style:
                          const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              /////////////////////////////////////////////
              /// GENERATE BUTTON

              SizedBox(
                width: double.infinity,
                height: 52,
                child:
                ElevatedButton.icon(
                  icon: const Icon(
                      Icons.auto_awesome),
                  label: const Text(
                      "Generate Summary"),
                  onPressed:
                  extractedText.isEmpty ||
                      isLoading
                      ? null
                      : generateSummary,
                ),
              ),

              const SizedBox(height: 20),

              /////////////////////////////////////////////
              /// LOADING

              if (isLoading)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                        "Generating summary..."),
                  ],
                ),

              /////////////////////////////////////////////
              /// SUMMARY

              if (summary.isNotEmpty)
                Expanded(
                  child:
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [

                        const Text(
                          "Summary",
                          style:
                          TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        Container(
                          padding:
                          const EdgeInsets
                              .all(16),
                          decoration:
                          BoxDecoration(
                            color: Colors
                                .grey.shade100,
                            borderRadius:
                            BorderRadius
                                .circular(
                                12),
                          ),
                          child: Text(
                            summary,
                            style:
                            const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),

                        const SizedBox(
                            height: 20),

                        /////////////////////////////////////
                        /// SAVE BUTTON

                        SizedBox(
                          width: double
                              .infinity,
                          height: 52,
                          child:
                          ElevatedButton.icon(
                            icon:
                            const Icon(
                                Icons.save),
                            label: isSaving
                                ? const Text(
                                "Saving...")
                                : const Text(
                                "Save Summary"),
                            onPressed: isSaving
                                ? null
                                : saveSummary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}