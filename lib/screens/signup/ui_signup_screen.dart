import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';
import 'package:prepvrse/common/resources/widgets/textfields/app_text_field.dart';
import 'package:prepvrse/models/app_user.dart';
import 'package:prepvrse/screens/signup/provider/confirm_password_text_controller_provider.dart';
import 'package:prepvrse/screens/signup/provider/email_text_controller_provider.dart';
import 'package:prepvrse/screens/signup/provider/name_text_controller_provider.dart';
import 'package:prepvrse/screens/signup/provider/password_text_controller_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool isRegisterLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    ref.read(emailTextControllerProvider).clear();
    ref.read(passwordTextControllerProvider).clear();
    ref.read(nameTextControllerProvider).clear();
    ref.read(confirmPasswordTextControllerProvider).clear();
    super.initState();
  }

  Future<User?> signUp(AppUser user) async {
    try {
      setState(() {
        isRegisterLoading = true;
      });

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      Get.toNamed('/login');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isRegisterLoading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final nameController = ref.watch(nameTextControllerProvider);
    final emailController = ref.watch(emailTextControllerProvider);
    final passwordController = ref.watch(passwordTextControllerProvider);
    final confirmPasswordController =
        ref.watch(confirmPasswordTextControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8, top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "PrepVRse",
                style: Styles.displayLargeBoldStyle.copyWith(
                  color: Styles.primaryColor,
                  fontSize: 32,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    AppTextField(
                      label: "Name",
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        } else if (!RegExp(r'^[a-z A-Z]').hasMatch(
                          value,
                        )) {
                          return "Enter Correct Name";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      label: "Email",
                      keyboardType: TextInputType.name,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(
                                r'^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})')
                            .hasMatch(
                          value,
                        )) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      label: "Password",
                      keyboardType: TextInputType.name,
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      label: "Confirm Password",
                      keyboardType: TextInputType.name,
                      controller: confirmPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm Password should have a value";
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          return "Both Passwords should match";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isRegisterLoading
                  ? const CircularProgressIndicator()
                  : AppTextButton(
                      text: "Sign Up",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          final email =
                              ref.read(emailTextControllerProvider).text;
                          final password =
                              ref.read(passwordTextControllerProvider).text;
                          final name =
                              ref.read(nameTextControllerProvider).text;

                          final user = AppUser(
                              email: email, password: password, name: name);
                          signUp(
                            user,
                          );
                        }
                      },
                      color: Styles.primaryColor,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
