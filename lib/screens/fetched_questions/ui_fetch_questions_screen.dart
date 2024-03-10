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
  List<String> _questions = [];
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
        Uri.parse('http://10.7.86.57:5000/api/extract?id=$documentId'),
      );
      if (response.statusCode == 200) {
        setState(() {
          final mydata = json.decode(response.body);
          String rawQuestions = mydata['generated_questions'];
          _questions =
              rawQuestions.split('\n').where((q) => q.isNotEmpty).toList();
          extracted_text = mydata['extracted_text'];
          isLoading = false;
        });
      } else {
        setState(() {
          _questions = ['Failed to load data'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _questions = ['Failed to load data: $e'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Questionnaire"),
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
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Questions',
                            style: Styles.displayXlBoldStyle,
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _questions.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    _questions[index],
                                    style:
                                        Styles.displayLargeNormalStyle.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                          ),
                        ),
                      ],
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
                disabled: _questions.length > 0 ? false : true,
              ),
            )
          ],
        ));
  }
}
