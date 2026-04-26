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
          content:
          Text("Passwords do not match"),
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
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        //////////////////////////////////////////////////////
        /// BLUE GRADIENT

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
                "Create Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                  FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Start learning smarter with AI",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 24),

              //////////////////////////////////////////////////////
              /// FORM CARD

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(24),

                  decoration:
                  const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.only(
                      topLeft:
                      Radius.circular(28),
                      topRight:
                      Radius.circular(28),
                    ),
                  ),

                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          //////////////////////////////////////////////////
                          /// FULL NAME

                          TextFormField(
                            controller:
                            nameController,

                            decoration:
                            InputDecoration(
                              hintText:
                              "Full Name",

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
                                BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 16),

                          //////////////////////////////////////////////////
                          /// EMAIL

                          TextFormField(
                            controller:
                            emailController,

                            decoration:
                            InputDecoration(
                              hintText:
                              "Email",

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
                                BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 16),

                          //////////////////////////////////////////////////
                          /// PASSWORD

                          TextFormField(
                            controller:
                            passwordController,
                            obscureText:
                            obscurePassword,

                            decoration:
                            InputDecoration(
                              hintText:
                              "Password",

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
                                BorderSide.none,
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

                          const SizedBox(
                              height: 16),

                          //////////////////////////////////////////////////
                          /// CONFIRM PASSWORD

                          TextFormField(
                            controller:
                            confirmPasswordController,
                            obscureText:
                            obscureConfirm,

                            decoration:
                            InputDecoration(
                              hintText:
                              "Confirm Password",

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
                                BorderSide.none,
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
                            ),
                          ),

                          const SizedBox(
                              height: 24),

                          //////////////////////////////////////////////////
                          /// BUTTON

                          SizedBox(
                            width:
                            double.infinity,
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
                                  : _signUp,

                              child: isLoading
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
                              height: 16),

                          //////////////////////////////////////////////////
                          /// SIGN IN

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children: [
                              const Text(
                                  "Already have an account?"),
                              TextButton(
                                onPressed: () {
                                  context.go(
                                      '/signin');
                                },
                                child: const Text(
                                  "Sign In",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}