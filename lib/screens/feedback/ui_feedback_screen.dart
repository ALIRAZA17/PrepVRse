import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prepvrse/screens/feedback/widgets/infocard.dart';

class FeedBackScreen extends StatefulWidget {
  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  Map<dynamic, dynamic> _data = {};
  bool isLoading = false;
  bool isTextExpanded = false;
  bool isRelevanceExpanded = false;
  @override
  void initState() {
    super.initState();
    dynamic arguments = Get.arguments;
    String documentId = arguments["id"];
    String extracted_text = arguments["text"];
    fetchData(documentId, extracted_text);
  }

  Future<void> fetchData(String documentId, String text) async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response response = await http.post(
        Uri.parse(
            'http://10.7.84.229:5000/api/audio_processing?id=$documentId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': documentId,
          'extracted_text': text,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          final mydata = json.decode(response.body);
          _data = mydata;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText = isTextExpanded
        ? _data["text"]
        : (_data["text"]?.substring(0, 350) ?? "") + "...";

    String relevanceText = isRelevanceExpanded
        ? _data["relevance"].trim()
        : (_data["relevance"]?.trim().substring(0, 350) ?? "") + "...";
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Fetching Feedback Hang Tight!!")
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoCard(
                          title: 'Sentiment Score',
                          value: _data["sentiment_score"].toString(),
                          color: Colors.blue,
                        ),
                        InfoCard(
                          title: 'Speech Rate',
                          value: _data["speech_rate"].toStringAsFixed(2),
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoCard(
                          title: 'Sentiment Class',
                          value: _data.isNotEmpty
                              ? _data["sentiment_class"].toString()
                              : 'N/A',
                          color: Colors.orange,
                        ),
                        InfoCard(
                          title: 'Vocab Difficulty',
                          value: _data.isNotEmpty
                              ? _data["difficulty_class"].toString()
                              : 'N/A',
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InfoCard(
                          title: 'Pitch',
                          value: _data.isNotEmpty
                              ? _data["average_pitch"].toStringAsFixed(2)
                              : 'N/A',
                          color: const Color.fromARGB(255, 234, 84, 134),
                        ),
                        InfoCard(
                          title: 'Grade Level',
                          value: _data.isNotEmpty
                              ? _data["grade_level"].toStringAsFixed(2)
                              : 'N/A',
                          color: Color.fromARGB(255, 233, 231, 92),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    if (_data.isNotEmpty)
                      Card(
                        color: const Color.fromARGB(255, 55, 39, 176),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Relevance between Slide Content & Audio',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                relevanceText,
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isRelevanceExpanded = !isRelevanceExpanded;
                                  });
                                },
                                child: Text(
                                  isRelevanceExpanded ? "See Less" : "See More",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 12),
                    if (_data.isNotEmpty)
                      Card(
                        color: Colors.purple,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Extracted Text from Audio',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                displayText,
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isTextExpanded =
                                        !isTextExpanded; // Toggle text expansion
                                  });
                                },
                                child: Text(
                                  isTextExpanded ? "See Less" : "See More",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
