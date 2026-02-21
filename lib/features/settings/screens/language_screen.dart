import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

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
        title: const Text('Language', style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildLanguageTile('English', true),
          _buildLanguageTile('Sinhala', false),
          _buildLanguageTile('Tamil', false),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(String language, bool isSelected) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(language, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blueAccent) : null,
        onTap: () {},
      ),
    );
  }
}