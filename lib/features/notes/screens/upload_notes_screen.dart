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

  ////////////////////////////////////////////////////////

  Future<void> pickFile() async {
    try {
      FilePickerResult? result =
      await FilePicker.platform
          .pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'txt',
          'pdf'
        ],
        withData: true,
      );

      if (result != null) {
        final file =
            result.files.single;

        fileName = file.name;

        if (file.bytes != null) {
          extractedText =
              utf8.decode(
                  file.bytes!);
        }

        setState(() {});
      } else {
        print(
            "User cancelled file picking");
      }
    } catch (e) {
      print(
          "File pick error: $e");
    }
  }

  ////////////////////////////////////////////////////////

  Future<void>
  generateSummary() async {
    if (extractedText.isEmpty)
      return;

    setState(
            () => isLoading = true);

    try {
      summary =
      await _aiService
          .summarizeText(
          extractedText);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Failed to generate summary"),
        ),
      );
    }

    setState(
            () => isLoading = false);
  }

  ////////////////////////////////////////////////////////

  Future<void>
  saveSummary() async {
    final user =
        FirebaseAuth.instance
            .currentUser;

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

    setState(
            () => isSaving = true);

    try {
      await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .collection(
          'summaries')
          .add({
        "title": fileName,
        "summary": summary,
        "createdAt":
        FieldValue
            .serverTimestamp(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Summary saved successfully"),
        ),
      );
    } catch (e) {
      print("Save error: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Failed to save summary"),
        ),
      );
    }

    setState(
            () => isSaving = false);
  }

  ////////////////////////////////////////////////////////

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Upload Notes"),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(
            20),

        child: Column(
          children: [

            ////////////////////////////////////////////////////
            /// Upload File Button

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: pickFile,
                child: const Text(
                    "Upload TXT / PDF File"),
              ),
            ),

            const SizedBox(
                height: 20),

            ////////////////////////////////////////////////////
            /// File Loaded

            if (extractedText
                .isNotEmpty)
              Column(
                children: [

                  const Text(
                    "File Loaded Successfully",
                    style:
                    TextStyle(
                      color:
                      Colors.green,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 20),

                  ////////////////////////////////////////////////////
                  /// Generate Summary Button

                  SizedBox(
                    width:
                    double.infinity,
                    height: 50,
                    child:
                    ElevatedButton(
                      onPressed:
                      generateSummary,
                      child:
                      const Text(
                        "Generate Summary",
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(
                height: 20),

            ////////////////////////////////////////////////////
            /// Loading

            if (isLoading)
              const CircularProgressIndicator(),

            ////////////////////////////////////////////////////
            /// Show Summary

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
                          fontSize:
                          18,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),

                      const SizedBox(
                          height:
                          10),

                      Text(
                        summary,
                        style:
                        const TextStyle(
                          fontSize:
                          16,
                        ),
                      ),

                      const SizedBox(
                          height:
                          20),

                      ////////////////////////////////////////////////////
                      /// Save Summary Button

                      SizedBox(
                        width:
                        double
                            .infinity,
                        height: 50,
                        child:
                        ElevatedButton.icon(
                          icon:
                          const Icon(
                              Icons
                                  .save),
                          label:
                          isSaving
                              ? const Text(
                              "Saving...")
                              : const Text(
                              "Save Summary"),
                          onPressed:
                          isSaving
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
    );
  }
}