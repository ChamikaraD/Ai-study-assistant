import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text("Privacy"),
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
                  Icons.privacy_tip_outlined,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 24),

            //////////////////////////////////////////////////////
            /// TITLE

            const Text(
              "Your Privacy Matters",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            //////////////////////////////////////////////////////
            /// SUBTITLE

            const Text(
              "We are committed to protecting your personal data and ensuring secure use of the AI Study Assistant.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            //////////////////////////////////////////////////////
            /// PRIVACY CARD

            _privacyCard(
              icon: Icons.lock_outline,
              title: "Secure Processing",
              description:
              "All lecture recordings and study materials are securely processed only to generate your personal study notes.",
            ),

            const SizedBox(height: 14),

            _privacyCard(
              icon: Icons.storage_outlined,
              title: "Data Storage",
              description:
              "Your files remain on your device or are securely stored in protected cloud infrastructure.",
            ),

            const SizedBox(height: 14),

            _privacyCard(
              icon: Icons.share_outlined,
              title: "No Data Sharing",
              description:
              "We do not share your educational data with third parties.",
            ),

            const SizedBox(height: 14),

            _privacyCard(
              icon: Icons.school_outlined,
              title: "Education Purpose Only",
              description:
              "Your data is used solely to improve your learning experience.",
            ),

            const SizedBox(height: 30),

            //////////////////////////////////////////////////////
            /// FOOTER NOTE

            Center(
              child: Text(
                "AI Study Assistant protects your privacy.",
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
  /// PRIVACY CARD WIDGET

  Widget _privacyCard({
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