import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    fetchData(userId);
  }

  Future<void> fetchData(String documentId) async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(documentId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        var sessionsData = snapshot.data() as Map<String, dynamic>;
        var sessionsList = sessionsData['sessions'] as List<dynamic>;
        if (sessionsList.isNotEmpty) {
          var lastSessionReport = sessionsList.last['reportGenerated'];
          setState(() {
            _data = lastSessionReport;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText = isTextExpanded
        ? _data["text"]
        : (_data["text"]?.length ?? 0) > 350
            ? _data["text"].substring(0, 350) + "..."
            : _data["text"] ?? "";

    String relevanceText = isRelevanceExpanded
        ? _data["relevance"].trim()
        : (_data["relevance"]?.length ?? 0) > 350
            ? _data["relevance"].trim().substring(0, 350) + "..."
            : _data["relevance"]?.trim() ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Text('Session Feedback'),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          color: Color.fromARGB(255, 176, 174, 42),
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
                                        !isTextExpanded;
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
