import 'package:flutter/material.dart';
import 'package:prepvrse/common/constants/styles.dart';

class SessionVR extends StatelessWidget {
  const SessionVR({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VRSession"),
        backgroundColor: Styles.primaryColor,
      ),
      body: Center(
        child: Text("Your Session has started. Please use your VR now!"),
      ),
    );
  }
}
