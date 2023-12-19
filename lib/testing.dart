import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  Future<String> recognizeSpeech() async {
    final ByteData data =
        await rootBundle.load('assets/audios/marketplace.mp3');
    final Uint8List bytes = data.buffer.asUint8List();
    final response = await http.post(
      Uri.parse("http://10.0.2.2:5000/recognize-speech"),
      headers: {"Content-Type": "application/octet-stream"},
      body: bytes,
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
                final data = await recognizeSpeech();
                print(data);
              },
              child: const Text(
                "Check",
              ),
            )
          ],
        ),
      ),
    );
  }
}
