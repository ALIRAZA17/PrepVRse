import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';
import 'package:prepvrse/common/resources/widgets/textfields/app_text_field.dart';
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
  @override
  Widget build(BuildContext context) {
    final nameController = ref.watch(nameTextControllerProvider);
    final emailController = ref.watch(eamilTextControllerProvider);
    final passwordController = ref.watch(passwordTextControllerProvider);
    final confirmPasswordController =
        ref.watch(confirmPasswordTextControllerProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
              label: "Name",
              keyboardType: TextInputType.name,
              controller: nameController,
              validator: (_) {
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
              validator: (_) {
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
              validator: (_) {
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
              validator: (_) {
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            AppTextButton(
              text: "Sign Up",
              onTap: () {},
              color: Styles.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
