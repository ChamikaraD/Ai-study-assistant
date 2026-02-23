import 'package:flutter/material.dart';
import '../../../services/ai_service.dart';
import '../../../core/constants/app_colors.dart';

class AskAiScreen extends StatefulWidget {
  const AskAiScreen({super.key});

  @override
  State<AskAiScreen> createState() => _AskAiScreenState();
}

class _AskAiScreenState extends State<AskAiScreen> {
  final TextEditingController _controller = TextEditingController();
  final AiService _aiService = AiService();

  String _response = "";
  bool _isLoading = false;

  Future<void> _askQuestion() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = "";
    });

    try {
      final result = await _aiService.askAI(question);

      setState(() {
        _response = result;
      });
    } catch (e) {
      setState(() {
        _response = "Error: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Ask AI"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Ask any study question...",
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _isLoading ? null : _askQuestion,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Ask"),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
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