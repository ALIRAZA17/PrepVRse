import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prepvrse/common/constants/styles.dart';
import 'dart:convert';

import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';

class GeneratedQuestionsScreen extends StatefulWidget {
  @override
  _GeneratedQuestionsScreenState createState() =>
      _GeneratedQuestionsScreenState();
}

class _GeneratedQuestionsScreenState extends State<GeneratedQuestionsScreen> {
  String _data = '';
  String extracted_text = "";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    dynamic arguments = Get.arguments;
    String documentId = arguments["id"];
    fetchData(documentId);
  }

  Future<void> fetchData(String documentId) async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response response = await http.get(
        Uri.parse('http://10.7.84.229:5000/api/extract?id=$documentId'),
      );
      if (response.statusCode == 200) {
        print(json.decode(response.body).toString());
        setState(() {
          final mydata = json.decode(response.body);
          _data = mydata['generated_questions'];
          extracted_text = mydata['extracted_text'];
          isLoading = false;
        });
      } else {
        setState(() {
          _data = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _data = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('API Data Fetching'),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      _data,
                    ),
            ),
            Positioned(
              left: 10,
              bottom: 5,
              right: 10,
              child: AppTextButton(
                text: "Next",
                onTap: () {
                  Get.toNamed(
                    '/audio_upload',
                    arguments: {
                      "extracted_text": extracted_text,
                    },
                  );
                },
                color: Styles.primaryColor,
              ),
            )
          ],
        ));
  }
}
