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
  bool isLoading = true;
  bool isTextExpanded = false;
  bool isRelevanceExpanded = false;
  bool hasData = false;
  String loadingMessage =
      "Your session is ongoing. Please complete your session.";
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchData(userId);
  }

  Future<void> fetchData(String documentId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(documentId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        var sessionsData = snapshot.data() as Map<String, dynamic>;
        var sessionsList = sessionsData['sessions'] as List<dynamic>;

        if (sessionsList.isNotEmpty) {
          var lastSession = sessionsList.last;

          if (lastSession['audioFilePath'] == "") {
            setState(() {
              loadingMessage =
                  "Your session is ongoing. Please complete your session.";
              isLoading = true;
              hasData = false;
            });
          } else {
            var lastSessionReport = lastSession['reportGenerated'];
            if (lastSessionReport != null) {
              setState(() {
                _data = lastSessionReport;
                isLoading = false;
                hasData = true;
              });
            } else {
              setState(() {
                loadingMessage = "Fetching Feedback, Hang Tight!";
                isLoading = true;
                hasData = false;
              });
            }
          }
        } else {
          setState(() {
            isLoading = false;
            hasData = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          hasData = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasData = false;
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
        : (_data["relevance"]?.length ?? 0) > 340
            ? _data["relevance"].trim().substring(0, 340) + "..."
            : _data["relevance"]?.trim() ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Text('Session Feedback', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading || !hasData
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(loadingMessage),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                color: Color.fromRGBO(5, 38, 57, 1.000),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InfoCard(
                                title: 'Sentiment Score',
                                value: _data["sentiment_score"].toString(),
                                dialogInfo:
                                    "Sentiment Score is a numerical value that represents the sentiment of the audio. The value ranges from -1 to 1. A value of 1 indicates a positive sentiment, a value of -1 indicates a negative sentiment, and a value of 0 indicates a neutral sentiment.",
                              ),
                              InfoCard(
                                title: 'Speech Rate',
                                value: _data["speech_rate"].toStringAsFixed(2),
                                dialogInfo:
                                    "Speech Rate is the speed at which a person speaks. It is measured in words per minute (WPM).",
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InfoCard(
                                title: 'Sentiment Class',
                                value: _data.isNotEmpty
                                    ? _data["sentiment_class"].toString()
                                    : 'N/A',
                                dialogInfo:
                                    "Sentiment Class is a classification of the sentiment score. It can be either Positive, Negative, or Neutral.",
                              ),
                              InfoCard(
                                title: 'Vocab Difficulty',
                                value: _data.isNotEmpty
                                    ? _data["difficulty_class"].toString()
                                    : 'N/A',
                                dialogInfo:
                                    "Vocabulary Difficulty is a classification of the vocabulary used in the audio. It can be either Easy, Medium, or Hard.",
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InfoCard(
                                title: 'Pitch',
                                value: _data.isNotEmpty
                                    ? _data["average_pitch"].toStringAsFixed(2)
                                    : 'N/A',
                                dialogInfo:
                                    "Pitch is the perceived frequency of a sound. It is measured in Hertz (Hz).",
                              ),
                              InfoCard(
                                title: 'Grade Level',
                                value: _data.isNotEmpty
                                    ? _data["grade_level"].toStringAsFixed(2)
                                    : 'N/A',
                                dialogInfo:
                                    "Grade level represents the class standard who can understand this pitch",
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          if (_data.isNotEmpty)
                            Card(
                              color: Color.fromARGB(255, 244, 242, 234),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Relevance between Slide Content & Audio',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      relevanceText,
                                      style: TextStyle(
                                        color: Colors.black45,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isRelevanceExpanded =
                                              !isRelevanceExpanded;
                                        });
                                      },
                                      child: Text(
                                        isRelevanceExpanded
                                            ? "See Less"
                                            : "See More",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 145, 139, 139)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: 12),
                          if (_data.isNotEmpty)
                            Card(
                              color: Color.fromRGBO(5, 38, 57, 1.000),
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.grey, width: 2.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Extracted Text from Audio',
                                      style: TextStyle(
                                        color: Colors.grey,
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
                                          isTextExpanded = !isTextExpanded;
                                        });
                                      },
                                      child: Text(
                                        isTextExpanded
                                            ? "See Less"
                                            : "See More",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
