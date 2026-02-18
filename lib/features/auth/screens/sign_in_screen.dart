import 'package:flutter/material.dart';
import '../../dashboard/dashboard_screen.dart';
import 'package:go_router/go_router.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/dashboard');
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}
