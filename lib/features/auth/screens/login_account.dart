import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/auth_service.dart';
import 'create_account.dart';

class LoginAccount extends StatefulWidget {
  const LoginAccount({super.key});

  @override
  State<LoginAccount> createState() =>
      _LoginAccountState();
}

class _LoginAccountState
    extends State<LoginAccount> {
  final AuthService _authService =
  AuthService();

  final _formKey =
  GlobalKey<FormState>();

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;
  bool isLoading = false;

  //////////////////////////////////////////////////////////////

  Future<void> login() async {
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

      if (context.mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text("Login failed"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  //////////////////////////////////////////////////////////////

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F7FF),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              //////////////////////////////////////////////////////
              /// HEADER

              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(
                    28),
                decoration:
                const BoxDecoration(
                  gradient:
                  LinearGradient(
                    colors: [
                      Color(0xFF4A6CF7),
                      Color(0xFF6A8DFF),
                    ],
                  ),
                  borderRadius:
                  BorderRadius.only(
                    bottomLeft:
                    Radius.circular(
                        30),
                    bottomRight:
                    Radius.circular(
                        30),
                  ),
                ),
                child: Column(
                  children: [

                    Image.asset(
                      "assets/images/icon.png",
                      height: 70,
                    ),

                    const SizedBox(
                        height: 12),

                    const Text(
                      "AI Study Assistant",
                      style:
                      TextStyle(
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Colors.white,
                      ),
                    ),

                    const SizedBox(
                        height: 6),

                    const Text(
                      "Smart learning powered by AI",
                      style:
                      TextStyle(
                        color:
                        Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              //////////////////////////////////////////////////////
              /// FORM

              Padding(
                padding:
                const EdgeInsets
                    .all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [

                      const SizedBox(
                          height: 10),

                      const Text(
                        "Welcome Back 👋",
                        style:
                        TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),

                      const SizedBox(
                          height: 6),

                      const Text(
                        "Login to continue your learning",
                        style:
                        TextStyle(
                          color:
                          Colors.grey,
                        ),
                      ),

                      const SizedBox(
                          height: 30),

                      //////////////////////////////////////////////////////
                      /// EMAIL

                      TextFormField(
                        controller:
                        emailController,
                        keyboardType:
                        TextInputType
                            .emailAddress,
                        decoration:
                        InputDecoration(
                          labelText:
                          "Email",
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
                          height: 18),

                      //////////////////////////////////////////////////////
                      /// PASSWORD

                      TextFormField(
                        controller:
                        passwordController,
                        obscureText:
                        obscurePassword,
                        decoration:
                        InputDecoration(
                          labelText:
                          "Password",
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
                          return null;
                        },
                      ),

                      const SizedBox(
                          height: 12),

                      //////////////////////////////////////////////////////
                      /// REMEMBER + FORGOT

                      Row(
                        children: [

                          Checkbox(
                            value:
                            rememberMe,
                            onChanged:
                                (value) {
                              setState(() {
                                rememberMe =
                                value!;
                              });
                            },
                          ),

                          const Text(
                              "Remember me"),

                          const Spacer(),

                          TextButton(
                            onPressed: () {},
                            child:
                            const Text(
                              "Forgot Password?",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 18),

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
                              : login,
                          child:
                          isLoading
                              ? const CircularProgressIndicator(
                            color:
                            Colors
                                .white,
                          )
                              : const Text(
                            "Log In",
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
                          height: 30),

                      //////////////////////////////////////////////////////
                      /// SIGN UP

                      Center(
                        child:
                        RichText(
                          text: TextSpan(
                            text:
                            "Don't have an account?",
                            style:
                            const TextStyle(
                              color:
                              Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text:
                                " Sign Up",
                                style:
                                const TextStyle(
                                  color:
                                  Colors
                                      .blue,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                                recognizer:
                                TapGestureRecognizer()
                                  ..onTap =
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                        const CreateAccount(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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