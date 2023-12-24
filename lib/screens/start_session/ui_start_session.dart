import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prepvrse/common/constants/styles.dart';
import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';

class StartSessionScreen extends ConsumerStatefulWidget {
  const StartSessionScreen({required this.isPresentation, super.key});
  final bool isPresentation;

  @override
  ConsumerState<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends ConsumerState<StartSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Styles.primaryColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Start New Session",
                    style: Styles.displayXlBoldStyle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                widget.isPresentation
                    ? Text(
                        "Attach your presentation",
                        style: Styles.displayLargeBoldStyle,
                      )
                    : Text(
                        "Attach your resume",
                        style: Styles.displayLargeBoldStyle,
                      ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(250, 249, 246, 1),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.upload_file),
                        iconSize: 40,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 10,
            bottom: 5,
            right: 10,
            child: AppTextButton(
              text: "Start Session",
              onTap: () {},
              color: Styles.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
