import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool obscurePassword = true;

  //////////////////////////////////////////////////////////////

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await _authService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted) {
        context.go('/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login Failed";

      if (e.code == 'user-not-found') {
        message = "No user found with this email.";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  //////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2563EB),
              Color(0xFF1E40AF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              //////////////////////////////////////////////////////
              /// HEADER

              const SizedBox(height: 24),

              Image.asset(
                "assets/logo.png",
                height: 110,
              ),

              const SizedBox(height: 12),

              const Text(
                "AI Study Assistant",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Your smart learning companion",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 24),

              //////////////////////////////////////////////////////
              /// LOGIN CARD

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),

                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),

                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,

                      children: [

                        //////////////////////////////////////////////////
                        /// EMAIL

                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText:
                            "Enter your email",

                            filled: true,
                            fillColor:
                            const Color(
                                0xFFF4F5F7),

                            border:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  12),
                              borderSide:
                              BorderSide
                                  .none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        //////////////////////////////////////////////////
                        /// PASSWORD

                        TextFormField(
                          controller:
                          passwordController,
                          obscureText:
                          obscurePassword,

                          decoration: InputDecoration(
                            hintText:
                            "Enter your password",

                            filled: true,
                            fillColor:
                            const Color(
                                0xFFF4F5F7),

                            border:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  12),
                              borderSide:
                              BorderSide
                                  .none,
                            ),

                            suffixIcon:
                            IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons
                                    .visibility_off
                                    : Icons
                                    .visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword =
                                  !obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        //////////////////////////////////////////////////
                        /// FORGOT PASSWORD

                        Align(
                          alignment:
                          Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.go(
                                  '/forgot-password');
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color(
                                    0xFF2563EB),
                                fontWeight:
                                FontWeight
                                    .w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        //////////////////////////////////////////////////
                        /// LOGIN BUTTON

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style:
                            ElevatedButton
                                .styleFrom(
                              backgroundColor:
                              const Color(
                                  0xFF2563EB),

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    12),
                              ),
                            ),
                            onPressed:
                            isLoading
                                ? null
                                : _login,
                            child: isLoading
                                ? const CircularProgressIndicator(
                              color:
                              Colors
                                  .white,
                            )
                                : const Text(
                              "Login",
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

                        const SizedBox(height: 20),

                        //////////////////////////////////////////////////
                        /// SIGN UP

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            const Text(
                                "Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                context.go(
                                    '/signup');
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Color(
                                      0xFF2563EB),
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}