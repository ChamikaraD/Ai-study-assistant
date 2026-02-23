import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 1. Added go_router import!

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          // 2. Updated to use context.pop()
          onPressed: () => context.pop(),
        ),
        title: const Text('Terms & Conditions', style: TextStyle(color: Colors.black)),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Text(
          'Terms of Use\n\nBy using the AI Study Assistant, you agree that the AI-generated summaries and answers are strictly based on the content you provide. \n\nThe AI may occasionally make mistakes. Please verify important information against your original lecture notes or recordings before your final exams.',
          style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
        ),
      ),
    );
  }
}