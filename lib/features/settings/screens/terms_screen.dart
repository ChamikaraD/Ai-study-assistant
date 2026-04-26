import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () => context.pop(),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            //////////////////////////////////////////////////////
            /// ICON HEADER

            Center(
              child: Container(
                padding:
                const EdgeInsets.all(18),
                decoration:
                BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 24),

            //////////////////////////////////////////////////////
            /// TITLE

            const Text(
              "Terms of Use",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Please read these terms carefully before using the AI Study Assistant.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            //////////////////////////////////////////////////////
            /// TERMS CARDS

            _termsCard(
              icon: Icons.smart_toy_outlined,
              title: "AI Generated Content",
              description:
              "All summaries and answers are generated automatically based on the content you provide to the AI Study Assistant.",
            ),

            const SizedBox(height: 14),

            _termsCard(
              icon: Icons.warning_amber_outlined,
              title: "Accuracy Notice",
              description:
              "The AI system may occasionally make mistakes. Always verify important academic information before relying on it for exams or assignments.",
            ),

            const SizedBox(height: 14),

            _termsCard(
              icon: Icons.school_outlined,
              title: "Educational Use Only",
              description:
              "This application is designed to support learning and study activities. It should not replace official course materials or instructor guidance.",
            ),

            const SizedBox(height: 14),

            _termsCard(
              icon: Icons.security_outlined,
              title: "User Responsibility",
              description:
              "You are responsible for reviewing generated summaries and ensuring they match your original lecture content.",
            ),

            const SizedBox(height: 30),

            //////////////////////////////////////////////////////
            /// FOOTER

            Center(
              child: Text(
                "Last updated: 2026",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////
  /// TERMS CARD WIDGET

  Widget _termsCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          //////////////////////////////////////////////////////
          /// ICON

          Container(
            padding:
            const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 14),

          //////////////////////////////////////////////////////
          /// TEXT

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}