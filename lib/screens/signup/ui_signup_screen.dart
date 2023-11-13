import 'package:flutter/material.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';
import 'package:prepvrse/common/resources/widgets/textfields/app_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

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
              controller: nameController,
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
              controller: nameController,
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
              controller: nameController,
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
