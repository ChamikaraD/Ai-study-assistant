import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() =>
      _SignInScreenState();
}

class _SignInScreenState
    extends State<SignInScreen> {
  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final AuthService _authService =
  AuthService();

  final _formKey =
  GlobalKey<FormState>();

  bool isLoading = false;
  bool obscurePassword = true;

  //////////////////////////////////////////////////////////////

  Future<void> _login() async {
    if (!_formKey.currentState!
        .validate()) return;

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
      String message =
          "Login Failed";

      if (e.code ==
          'user-not-found') {
        message =
        "No user found with this email.";
      } else if (e.code ==
          'wrong-password') {
        message =
        "Incorrect password.";
      } else if (e.code ==
          'invalid-email') {
        message =
        "Invalid email format.";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
          Text(message),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Something went wrong"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  //////////////////////////////////////////////////////////////

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F7FF),

      body: SafeArea(
        child:
        SingleChildScrollView(
          padding:
          const EdgeInsets.all(
              24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [

                //////////////////////////////////////////////////////
                /// HEADER

                Center(
                  child: Column(
                    children: [

                      Image.asset(
                        "assets/logo.png",
                        height: 80,
                      ),

                      const SizedBox(
                          height: 12),

                      const Text(
                        "AI Study Assistant",
                        style:
                        TextStyle(
                          fontSize: 24,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),

                      const SizedBox(
                          height: 6),

                      const Text(
                        "Welcome back! Continue your learning",
                        style:
                        TextStyle(
                          color:
                          Colors.grey,
                        ),
                        textAlign:
                        TextAlign
                            .center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height: 40),

                //////////////////////////////////////////////////////
                /// EMAIL

                const Text(
                  "Email",
                  style:
                  TextStyle(
                    fontWeight:
                    FontWeight
                        .w600,
                  ),
                ),

                const SizedBox(
                    height: 8),

                TextFormField(
                  controller:
                  emailController,
                  keyboardType:
                  TextInputType
                      .emailAddress,
                  decoration:
                  InputDecoration(
                    hintText:
                    "Enter your email",
                    prefixIcon:
                    const Icon(
                      Icons
                          .email_outlined,
                    ),
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          12),
                    ),
                  ),
                  validator:
                      (value) {
                    if (value ==
                        null ||
                        value
                            .isEmpty) {
                      return "Enter email";
                    }

                    return null;
                  },
                ),

                const SizedBox(
                    height: 20),

                //////////////////////////////////////////////////////
                /// PASSWORD

                const Text(
                  "Password",
                  style:
                  TextStyle(
                    fontWeight:
                    FontWeight
                        .w600,
                  ),
                ),

                const SizedBox(
                    height: 8),

                TextFormField(
                  controller:
                  passwordController,
                  obscureText:
                  obscurePassword,
                  decoration:
                  InputDecoration(
                    hintText:
                    "Enter password",
                    prefixIcon:
                    const Icon(
                      Icons
                          .lock_outline,
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
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          12),
                    ),
                  ),
                  validator:
                      (value) {
                    if (value ==
                        null ||
                        value
                            .isEmpty) {
                      return "Enter password";
                    }

                    if (value.length <
                        6) {
                      return "Minimum 6 characters";
                    }

                    return null;
                  },
                ),

                const SizedBox(
                    height: 12),

                //////////////////////////////////////////////////////
                /// FORGOT PASSWORD

                Align(
                  alignment:
                  Alignment
                      .centerRight,
                  child:
                  TextButton(
                    onPressed: () {
                      // future feature
                    },
                    child:
                    const Text(
                      "Forgot Password?",
                    ),
                  ),
                ),

                const SizedBox(
                    height: 16),

                //////////////////////////////////////////////////////
                /// LOGIN BUTTON

                SizedBox(
                  width:
                  double.infinity,
                  height: 52,
                  child:
                  ElevatedButton(
                    onPressed:
                    isLoading
                        ? null
                        : _login,
                    child:
                    isLoading
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

                const SizedBox(
                    height: 24),

                //////////////////////////////////////////////////////
                /// SIGN UP

                Center(
                  child:
                  TextButton(
                    onPressed: () {
                      context.go(
                          '/signup');
                    },
                    child:
                    const Text(
                      "Don't have an account? Sign Up",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}