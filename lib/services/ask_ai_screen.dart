import 'package:flutter/material.dart';
import '../../../services/openai_services.dart';
import '../../../services/chat_service.dart';


class AskAiScreen extends StatefulWidget {
  const AskAiScreen({super.key});

  @override
  State<AskAiScreen> createState() => _AskAiScreenState();
}

class _AskAiScreenState extends State<AskAiScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final OpenAIService _aiService = OpenAIService();
  final ChatService _chatService = ChatService();

  List<Map<String, String>> messages = [];

  bool isLoading = false;

  /// =========================
  /// SEND MESSAGE
  /// =========================
  Future<void> sendMessage() async {
    String question = _controller.text.trim();

    if (question.isEmpty) return;

    setState(() {
      messages.add({
        "role": "user",
        "text": question,
      });

      isLoading = true;
    });

    _controller.clear();

    try {
      /// GET AI RESPONSE
      final response = await _aiService.askQuestion(
        question: question,
        systemPrompt: getSystemPrompt(),
      );

      /// SHOW MESSAGE
      setState(() {
        messages.add({
          "role": "ai",
          "text": response,
        });

        isLoading = false;
      });

      /// SAVE TO FIRESTORE
      await _chatService.saveChat(
        question: question,
        answer: response,
        mode: widget.mode,
      );

    } catch (e) {
      setState(() {
        isLoading = false;

        messages.add({
          "role": "ai",
          "text": "Something went wrong",
        });
      });

      print("AI error: $e");
    }
  }

  /// =========================
  /// AUTO SCROLL
  /// =========================
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// =========================
  /// UI
  /// =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask AI"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          /// EMPTY STATE
          if (messages.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Ask anything about your studies 📚",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

          /// CHAT MESSAGES
          if (messages.isNotEmpty)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                  bool isUser =
                      message["role"] == "user";

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6),
                      padding: const EdgeInsets.all(14),
                      constraints:
                      const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blue
                            : Colors.grey.shade200,
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      child: Text(
                        message["text"]!,
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          /// TYPING INDICATOR
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.start,
                children: [
                  SizedBox(width: 16),
                  CircularProgressIndicator(),
                ],
              ),
            ),

          /// INPUT AREA
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.2,
                ),
              ),
            ),
            child: Row(
              children: [

                /// TEXT FIELD
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Ask anything...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// SEND BUTTON
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}