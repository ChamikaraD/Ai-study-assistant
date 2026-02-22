import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final email = user?.email ?? '';
    final name = email.isNotEmpty ? email.split('@')[0] : 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
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

            /// PROFILE SECTION
            const CircleAvatar(
              radius: 45,
              backgroundImage:
              NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 12),

            /// USER NAME
            Text(
              'Hi $name',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            /// MANAGE ACCOUNT
            SizedBox(
              height: 34,
              child: OutlinedButton(
                onPressed: () {
                  context.go('/manage-account');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Color(0xFFB0C4DE), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24),
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

            /// SETTINGS OPTIONS
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    trailingText: 'English',
                    onTap: () {
                      context.go('/language');
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildSettingsTile(
                    icon: Icons.shield_outlined,
                    title: 'Privacy',
                    onTap: () {
                      context.go('/privacy');
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildSettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () {
                      context.go('/terms');
                    },
                  ),
                  const SizedBox(height: 20),

                  /// LOGOUT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () async {
                        await _authService.signOut();

                        if (context.mounted) {
                          context.go('/signin');
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Colors.red, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10),
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

  /// SETTINGS TILE WIDGET
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFD6E4FF), width: 1.2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 0),
        dense: true,
        leading: Icon(icon,
            color: Colors.black54, size: 22),
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
                style: const TextStyle(
                    color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.arrow_forward_ios,
                color: Colors.grey, size: 14),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}