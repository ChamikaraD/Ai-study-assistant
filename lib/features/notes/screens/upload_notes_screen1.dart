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
          content:
          Text("Failed to pick file"),
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

    summary =
    await _aiService.summarizeText(
      extractedText,
    );

    setState(() {
      isLoading = false;
    });
  }

  /////////////////////////////////////////////////////////////

  Future<void> saveSummary() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (summary.isEmpty) return;

    setState(() {
      isSaving = true;
    });

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
        content:
        Text("Summary saved"),
      ),
    );

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
          const EdgeInsets.all(20),
          child: Column(
            children: [

              //////////////////////////////////////////////////////
              /// UPLOAD BOX

              GestureDetector(
                onTap: pickFile,
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets
                      .symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),

                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius
                        .circular(
                        16),

                    border: Border.all(
                      color: Colors
                          .grey
                          .shade400,
                      width: 1.5,
                    ),
                  ),

                  child: Column(
                    children: [

                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 60,
                        color: Colors
                            .grey
                            .shade600,
                      ),

                      const SizedBox(
                          height: 16),

                      const Text(
                        "Drag & drop your file here",
                        style:
                        TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),

                      const SizedBox(
                          height: 6),

                      const Text(
                        "or",
                        style:
                        TextStyle(
                          color:
                          Colors.grey,
                        ),
                      ),

                      const SizedBox(
                          height: 16),

                      //////////////////////////////////////////////////////
                      /// SELECT BUTTON

                      ElevatedButton(
                        onPressed: pickFile,
                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          const Color(
                              0xFF2563EB),

                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                                10),
                          ),
                        ),
                        child:
                        const Text(
                          "Select File",
                        ),
                      ),

                      const SizedBox(
                          height: 16),

                      Text(
                        "Supported formats",
                        style:
                        TextStyle(
                          color: Colors
                              .grey
                              .shade600,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(
                          height: 4),

                      const Text(
                        ".txt, .pdf",
                        style:
                        TextStyle(
                          fontSize: 12,
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //////////////////////////////////////////////////////
              /// FILE NAME

              if (fileName.isNotEmpty)
                Text(
                  fileName,
                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 20),

              //////////////////////////////////////////////////////
              /// GENERATE BUTTON

              if (extractedText
                  .isNotEmpty)
                SizedBox(
                  width:
                  double.infinity,
                  height: 50,
                  child:
                  ElevatedButton(
                    onPressed:
                    isLoading
                        ? null
                        : generateSummary,
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color:
                      Colors
                          .white,
                    )
                        : const Text(
                      "Generate Summary",
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              //////////////////////////////////////////////////////
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
                            FontWeight
                                .bold,
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
                                .grey
                                .shade100,
                            borderRadius:
                            BorderRadius
                                .circular(
                                12),
                          ),
                          child: Text(
                            summary,
                          ),
                        ),

                        const SizedBox(
                            height: 20),

                        SizedBox(
                          width: double
                              .infinity,
                          height: 50,
                          child:
                          ElevatedButton(
                            onPressed:
                            isSaving
                                ? null
                                : saveSummary,
                            child:
                            const Text(
                              "Save Summary",
                            ),
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