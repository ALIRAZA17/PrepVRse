import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';
import 'package:prepvrse/common/resources/widgets/textfields/app_text_field.dart';
import 'package:prepvrse/screens/signup/provider/email_text_controller_provider.dart';
import 'package:prepvrse/screens/signup/provider/password_text_controller_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    ref.read(emailTextControllerProvider).clear();
    ref.read(passwordTextControllerProvider).clear();
    initialization();
    super.initState();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final emailController = ref.watch(emailTextControllerProvider);
    final passwordController = ref.watch(passwordTextControllerProvider);

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
              height: 20,
            ),
            AppTextButton(
              text: "Login",
              onTap: () {},
              color: Styles.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
