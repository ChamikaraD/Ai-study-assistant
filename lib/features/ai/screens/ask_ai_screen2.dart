import 'package:flutter/material.dart';


class AskAIScreen extends StatelessWidget {
  const AskAIScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Ask AI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Column(
            children: [
              const Spacer(),

              /// Question Bubble
              const Align(
                alignment: Alignment.centerRight,
                child: ChatBubble(
                  text: "What is photosynthesis ?",
                  isUser: true,
                ),
              ),

              const SizedBox(height: 12),

              /// AI Answer Bubble
              const Align(
                alignment: Alignment.centerLeft,
                child: ChatBubble(
                  text:
                      "Photosynthesis is the essential biological process by which green plants, algae, and some bacteria convert light energy (sunlight) into chemical energy (glucose) to fuel their growth. Using chlorophyll, these organisms transform carbon dioxide and water into glucose (food) and release oxygen as a byproduct, supporting nearly all life on Earth.\n\nSource : Biology Notes\nConfidence : High",
                  isUser: false,
                ),
              ),

              const Spacer(),

              /// Input Field
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Ask questions......",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
