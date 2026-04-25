import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/huggingface_service.dart';
import '../../notes/screens/summary_screen.dart';

class RecordLectureScreen extends StatefulWidget {
  const RecordLectureScreen({super.key});

  @override
  State<RecordLectureScreen> createState() => _RecordLectureScreenState();
}

class _RecordLectureScreenState extends State<RecordLectureScreen> {
  final SpeechToText _speech = SpeechToText();
  final HuggingFaceService _aiService = HuggingFaceService();

  bool _isListening = false;
  bool _isLoading = false;

  String _spokenText = "";
  String _summary = "";

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    await Permission.microphone.request();
  }

  Future<void> startListening() async {
    bool available = await _speech.initialize();

    if (available) {
      setState(() => _isListening = true);

      _speech.listen(
        onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
          });
        },
      );
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> generateSummary() async {
    if (_spokenText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No speech detected")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _aiService.summarizeText(_spokenText);

      setState(() {
        _summary = result;
        _isLoading = false;
      });

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SummaryScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Lecture"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Mic Button
            GestureDetector(
              onTap: _isListening
                  ? stopListening
                  : startListening,
              child: CircleAvatar(
                radius: 40,
                backgroundColor:
                _isListening ? Colors.red : Colors.blue,
                child: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Recognized Speech:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _spokenText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 10),

            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: generateSummary,
              child: const Text("Generate Summary"),
            ),
          ],
        ),
      ),
    );
  }
}