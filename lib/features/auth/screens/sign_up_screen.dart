import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState
    extends State<SignUpScreen> {
  final nameController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

  final AuthService _authService =
  AuthService();

  final _formKey =
  GlobalKey<FormState>();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  ////////////////////////////////////////////////////////////

  Future<void> _signUp() async {
    if (!_formKey.currentState!
        .validate()) return;

    if (passwordController.text !=
        confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Passwords do not match"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _authService.signUp(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted) {
        context.go('/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      String message =
          "Sign Up Failed";

      if (e.code ==
          'email-already-in-use') {
        message =
        "Email already in use.";
      } else if (e.code ==
          'weak-password') {
        message =
        "Password must be at least 6 characters.";
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
    }

    setState(() {
      isLoading = false;
    });
  }

  ////////////////////////////////////////////////////////////

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////

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
                        "Create Account",
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
                        "Start learning smarter with AI",
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
                /// FULL NAME

                const Text(
                  "Full Name",
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
                  nameController,
                  decoration:
                  InputDecoration(
                    hintText:
                    "Enter your name",
                    prefixIcon:
                    const Icon(
                      Icons.person_outline,
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
                      return "Enter name";
                    }
                    return null;
                  },
                ),

                const SizedBox(
                    height: 20),

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
                      Icons.email_outlined,
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
                      Icons.lock_outline,
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
                    height: 20),

                //////////////////////////////////////////////////////
                /// CONFIRM PASSWORD

                const Text(
                  "Confirm Password",
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
                  confirmPasswordController,
                  obscureText:
                  obscureConfirm,
                  decoration:
                  InputDecoration(
                    hintText:
                    "Confirm password",
                    prefixIcon:
                    const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon:
                    IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons
                            .visibility_off
                            : Icons
                            .visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirm =
                          !obscureConfirm;
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
                ),

                const SizedBox(
                    height: 30),

                //////////////////////////////////////////////////////
                /// CREATE ACCOUNT BUTTON

                SizedBox(
                  width:
                  double.infinity,
                  height: 52,
                  child:
                  ElevatedButton(
                    onPressed:
                    isLoading
                        ? null
                        : _signUp,
                    child:
                    isLoading
                        ? const CircularProgressIndicator(
                      color:
                      Colors
                          .white,
                    )
                        : const Text(
                      "Create Account",
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
                /// SIGN IN

                Center(
                  child:
                  TextButton(
                    onPressed: () {
                      context.go(
                          '/signin');
                    },
                    child:
                    const Text(
                      "Already have an account? Sign In",
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