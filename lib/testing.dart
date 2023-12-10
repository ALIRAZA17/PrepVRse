import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  Future<String> recognizeSpeech(String audioFilePath) async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:5000"),
      body: {'audioFilePath': audioFilePath},
    );

    if (response.statusCode == 200) {
      final data = response.body;
      final decodedData = json.decode(data);
      return decodedData['text'];
    } else {
      throw Exception('Failed to recognize speech');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Check Text to Speech"),
            const SizedBox(),
            TextButton(
                onPressed: () async {
                  final data =
                      await recognizeSpeech("assets/audios/marketplace.mp3");
                  print(data);
                },
                child: const Text("Check"))
          ],
        ),
      ),
    );
  }
}
