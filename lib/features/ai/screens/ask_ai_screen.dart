import 'package:flutter/material.dart';
import '../../../services/openai_services.dart';

class AskAiScreen extends StatefulWidget {
  final String mode;

  const AskAiScreen({
    super.key,
    this.mode = "general",
  });

  @override
  State<AskAiScreen> createState() => _AskAiScreenState();
}

class _AskAiScreenState extends State<AskAiScreen> {
  final TextEditingController _controller =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();

  final OpenAIService _aiService =
  OpenAIService();

  List<Map<String, String>> messages = [];

  bool isLoading = false;

  /// SYSTEM PROMPT
  String getSystemPrompt() {
    if (widget.mode == "education") {
      return """
You are an AI Study Assistant.

Only answer educational questions such as:

- Mathematics
- Science
- Programming
- Exams
- Homework
- Study notes

If the question is NOT educational,
politely respond:

"I can only help with education-related questions."
""";
    }

    return "You are a helpful AI assistant.";
  }

  /// SEND MESSAGE
  Future<void> sendMessage() async {
    String question =
    _controller.text.trim();

    if (question.isEmpty) return;

    setState(() {
      messages.add({
        "role": "user",
        "text": question,
      });

      isLoading = true;
    });

    _controller.clear();

    _scrollToBottom();

    try {
      final response =
      await _aiService.askQuestion(
        question: question,
        systemPrompt: getSystemPrompt(),
      );

      setState(() {
        messages.add({
          "role": "ai",
          "text": response,
        });

        isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        isLoading = false;

        messages.add({
          "role": "ai",
          "text":
          "Something went wrong. Try again.",
        });
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 200),
          () {
        if (_scrollController
            .hasClients) {
          _scrollController.animateTo(
            _scrollController
                .position.maxScrollExtent,
            duration:
            const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == "education"
              ? "Study Assistant"
              : "Ask AI",
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [

          /// EMPTY STATE
          if (messages.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  widget.mode ==
                      "education"
                      ? "Ask your study questions 📚"
                      : "Ask anything 🤖",
                  style:
                  const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

          /// CHAT
          if (messages.isNotEmpty)
            Expanded(
              child: ListView.builder(
                controller:
                _scrollController,
                padding:
                const EdgeInsets.all(16),
                itemCount:
                messages.length,
                itemBuilder:
                    (context, index) {
                  final message =
                  messages[index];

                  bool isUser =
                      message["role"] ==
                          "user";

                  return Align(
                    alignment: isUser
                        ? Alignment
                        .centerRight
                        : Alignment
                        .centerLeft,
                    child: Container(
                      margin:
                      const EdgeInsets
                          .symmetric(
                        vertical: 6,
                      ),
                      padding:
                      const EdgeInsets
                          .all(14),
                      constraints:
                      const BoxConstraints(
                        maxWidth: 280,
                      ),
                      decoration:
                      BoxDecoration(
                        color: isUser
                            ? Colors.blue
                            : Colors
                            .grey
                            .shade200,
                        borderRadius:
                        BorderRadius
                            .circular(
                          16,
                        ),
                      ),
                      child: Text(
                        message["text"]!,
                        style:
                        TextStyle(
                          color: isUser
                              ? Colors.white
                              : Colors
                              .black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          if (isLoading)
            const Padding(
              padding:
              EdgeInsets.all(10),
              child:
              CircularProgressIndicator(),
            ),

          /// INPUT
          Container(
            padding:
            const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                    _controller,
                    onSubmitted:
                        (_) =>
                        sendMessage(),
                    decoration:
                    const InputDecoration(
                      hintText:
                      "Ask question...",
                      border:
                      OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon:
                  const Icon(Icons.send),
                  onPressed:
                  sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}