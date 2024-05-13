import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';

class SessionVR extends StatelessWidget {
  const SessionVR({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VRSession"),
        backgroundColor: Styles.primaryColor,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text("Your Session has started. Please use your VR now!"),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 15,
            right: 10,
            child: AppTextButton(
              text: "Get Results",
              onTap: () => Get.toNamed('/new_feedback'),
              color: Styles.primaryColor,
              disabled: false,
            ),
          )
        ],
      ),
    );
  }
}
