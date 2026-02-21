import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Privacy', style: TextStyle(color: Colors.black)),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Text(
          'Your privacy is important to us. \n\nAll lecture audio recordings and study materials you upload to the AI Study Assistant remain strictly on your device or are securely processed by our servers only for the purpose of generating your personal study notes. \n\nWe do not share your educational data with third parties.',
          style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
        ),
      ),
    );
  }
}