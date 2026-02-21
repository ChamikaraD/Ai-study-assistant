import 'package:flutter/material.dart';

// Import the sub-screens we created earlier
import 'manage_account_screen.dart';
import 'language_screen.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // The exact light blueish-grey background from the design
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40, // Brings the back arrow closer to the title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {}, // Add navigation logic if needed
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // --- Profile Section ---
            const CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with your actual asset or network image
            ),
            const SizedBox(height: 12),
            const Text(
              'Hi ! Sarah',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Manage Account Button
            SizedBox(
              height: 34, // Exact slim height from the screenshot
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to Manage Account Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ManageAccountScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFB0C4DE), width: 1.5), // Faint blue border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Fully rounded ends
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: const Text(
                  'Manage Your Account',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // --- Settings Options ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    trailingText: 'English',
                    onTap: () {
                      // Navigate to Language Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LanguageScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildSettingsTile(
                    icon: Icons.shield_outlined,
                    title: 'Privacy',
                    onTap: () {
                      // Navigate to Privacy Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildSettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions', // Corrected from the screenshot's double "Privacy" typo
                    onTap: () {
                      // Navigate to Terms Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TermsScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // --- Logout Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        // Add your Firebase logout logic here later
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded rectangle, not pill
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget updated to require an onTap callback
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap, // We added this line
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6E4FF), width: 1.2), // The exact soft blue border
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        dense: true, // Keeps the row tight like in the design
        leading: Icon(icon, color: Colors.black54, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
          ],
        ),
        onTap: onTap, // This connects the tap event to the function passed in
      ),
    );
  }
}