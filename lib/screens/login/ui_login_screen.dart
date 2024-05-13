import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';
import 'package:prepvrse/common/resources/widgets/textfields/app_text_field.dart';
import 'package:prepvrse/screens/login/provider/email_text_controller_provider.dart';
import 'package:prepvrse/screens/login/provider/password_text_controller_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  Future<void> signIn(String email, String password) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offNamed('/mode_type');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    ref.read(emailTextControllerProvider).clear();
    ref.read(passwordTextControllerProvider).clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emailController = ref.watch(emailTextControllerProvider);
    final passwordController = ref.watch(passwordTextControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Login")),
        backgroundColor: Styles.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 8, right: 18),
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
              AppTextField(
                key: ValueKey('emailTextField'),
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
                key: ValueKey('passwordTextField'),
                label: "Password",
                keyboardType: TextInputType.name,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : AppTextButton(
                      text: "Login",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          final email =
                              ref.read(emailTextControllerProvider).text;
                          final password =
                              ref.read(passwordTextControllerProvider).text;
                          await signIn(email, password);
                        }
                      },
                      color: Styles.primaryColor,
                    ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/signup');
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Styles.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
