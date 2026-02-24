import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import '../../../services/hf_ai_service.dart';

class UploadNotesScreen extends StatefulWidget {
  const UploadNotesScreen({super.key});

  @override
  State<UploadNotesScreen> createState() => _UploadNotesScreenState();
}

class _UploadNotesScreenState extends State<UploadNotesScreen> {
  final HuggingFaceService _aiService = HuggingFaceService();

  String extractedText = "";
  String summary = "";
  bool isLoading = false;

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt','pdf'],
        withData: true,
      );

      if (result != null) {
        final file = result.files.single;

        if (file.bytes != null) {
          extractedText = utf8.decode(file.bytes!);
        }

        setState(() {});
      } else {
        print("User cancelled file picking");
      }
    } catch (e) {
      print("File pick error: $e");
    }
  }

  Future<void> generateSummary() async {
    if (extractedText.isEmpty) return;

    setState(() => isLoading = true);

    summary = await _aiService.summarizeText(extractedText);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Notes")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: const Text("Upload TXT File"),
            ),
            const SizedBox(height: 20),

            if (extractedText.isNotEmpty)
              const Text("File Loaded Successfully"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: generateSummary,
              child: const Text("Generate Summary"),
            ),

            const SizedBox(height: 20),

            if (isLoading)
              const CircularProgressIndicator(),

            if (summary.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    summary,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}