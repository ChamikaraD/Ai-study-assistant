import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      context.go('/dashboard');
    } else {
      context.go('/signin');
    }
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCADAFE),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          children: [

            const Spacer(),

            /// App Icon
            Image.asset(
              "assets/logo.png",
              width: 110,
            ),

            const SizedBox(height: 20),

            /// App Name
            const Text(
              "AI Study Assistant",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 8),

            /// Subtitle
            const Text(
              "Learn Smarter With AI",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            /// Bottom Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(const Color(0xFFB2BCFE)),
                _buildDot(const Color(0xFF9CA9FF)),
                _buildDot(const Color(0xFF8E9CFE)),
                _buildDot(const Color(0xFF8091FE)),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}