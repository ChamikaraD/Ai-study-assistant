import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  final AuthService _authService =
  AuthService();

  String _userName = "User";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  ////////////////////////////////////////////////////////

  Future<void> _loadUserData() async {
    final user =
        _authService.currentUser;

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final doc =
      await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        _userName =
            doc.data()?['name'] ??
                "User";
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  ////////////////////////////////////////////////////////

  Future<void> _logout() async {
    await _authService.signOut();

    if (context.mounted) {
      context.go('/signin');
    }
  }

  ////////////////////////////////////////////////////////

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF4F6FA),

      appBar: AppBar(
        title:
        const Text("Settings"),
        centerTitle: true,
      ),

      body: _isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          children: [

            ////////////////////////////////////////////////////
            /// AVATAR

            CircleAvatar(
              radius: 45,
              backgroundColor:
              Colors.blue,
              child: Text(
                _userName
                    .isNotEmpty
                    ? _userName[0]
                    .toUpperCase()
                    : "U",
                style:
                const TextStyle(
                  fontSize: 32,
                  color:
                  Colors.white,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            ////////////////////////////////////////////////////
            /// USERNAME

            Text(
              _userName,
              style:
              const TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            ////////////////////////////////////////////////////
            /// SETTINGS CARDS

            _settingsCard(
              icon:
              Icons.language,
              title: "Language",
              subtitle:
              "English",
              onTap: () =>
                  context.push(
                      '/language'),
            ),

            const SizedBox(height: 12),

            _settingsCard(
              icon:
              Icons
                  .shield_outlined,
              title: "Privacy",
              onTap: () =>
                  context.push(
                      '/privacy'),
            ),

            const SizedBox(height: 12),

            _settingsCard(
              icon: Icons
                  .description_outlined,
              title:
              "Terms & Conditions",
              onTap: () =>
                  context.push(
                      '/terms'),
            ),

            const SizedBox(height: 30),

            ////////////////////////////////////////////////////
            /// LOGOUT BUTTON

            SizedBox(
              width:
              double.infinity,
              height: 52,
              child:
              ElevatedButton(
                onPressed:
                _logout,
                style:
                ElevatedButton
                    .styleFrom(
                  backgroundColor:
                  Colors.red,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                        12),
                  ),
                ),
                child:
                const Text(
                  "Logout",
                  style:
                  TextStyle(
                    fontSize:
                    16,
                    fontWeight:
                    FontWeight
                        .bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////

  Widget _settingsCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(14),
      child: Container(
        padding:
        const EdgeInsets.all(16),
        decoration:
        BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(14),
          border: Border.all(
            color:
            const Color(
                0xFFE5E7EB),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.04),
              blurRadius: 10,
              offset:
              const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [

            ////////////////////////////////////////
            /// ICON

            Container(
              padding:
              const EdgeInsets
                  .all(10),
              decoration:
              BoxDecoration(
                color:
                Colors.blue
                    .shade50,
                borderRadius:
                BorderRadius
                    .circular(
                    10),
              ),
              child: Icon(
                icon,
                color:
                Colors.blue,
              ),
            ),

            const SizedBox(width: 14),

            ////////////////////////////////////////
            /// TEXT

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [

                  Text(
                    title,
                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight
                          .w600,
                    ),
                  ),

                  if (subtitle != null)
                    Text(
                      subtitle,
                      style:
                      const TextStyle(
                        color:
                        Colors.grey,
                      ),
                    ),
                ],
              ),
            ),

            ////////////////////////////////////////
            /// ARROW

            const Icon(
              Icons
                  .arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}