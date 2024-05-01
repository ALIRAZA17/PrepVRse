import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prepvrse/common/constants/styles.dart';
import 'dart:convert';

import 'package:prepvrse/common/resources/widgets/buttons/app_text_button.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/ui_mode_type_screen.dart';

class GeneratedQuestionsScreen extends StatefulWidget {
  @override
  _GeneratedQuestionsScreenState createState() =>
      _GeneratedQuestionsScreenState();
}

class _GeneratedQuestionsScreenState extends State<GeneratedQuestionsScreen> {
  List<String> _questions = [];
  String extracted_text = "";
  bool isLoading = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;
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
        Uri.parse(
            'http://10.7.237.87:5000/api/extract?id=$documentId&userId=$userId'),
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

        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          final userDocRef =
              FirebaseFirestore.instance.collection('sessions').doc(userId);
          final docSnapshot = await userDocRef.get();

          if (docSnapshot.exists &&
              docSnapshot.data()?.containsKey('sessions') == true) {
            List<dynamic> sessions = List.from(docSnapshot.data()!['sessions']);
            if (sessions.isNotEmpty) {
              sessions.last['questionsGenerated'] = _questions;
              sessions.last['status'] = StatusOption.questionsGenerated.name;
              await userDocRef.update({'sessions': sessions});
            }
          }
        }
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
          title: const Text("Questionnaire",style: TextStyle(color: Colors.white),),
          backgroundColor: Styles.primaryColor,

        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                    color: Color.fromRGBO(5, 38, 57, 1.000),
                    child: Column(
                        children: [
                          SizedBox(height: 20),
                          Expanded(
                            child: ListView.separated(
                              itemCount: _questions.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Card(
                                    color: Color.fromARGB(255, 244, 242, 234),
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
            ),
            Positioned(
              left: 10,
              bottom: 15,
              right: 10,
              child: AppTextButton(
                text: "Start Session",
                onTap: () => Get.toNamed('/migrate_to_vr'),
                color: Styles.primaryColor,
                disabled: _questions.length > 0 ? false : true,
                borderColor: Styles.primaryColor,
              ),
            )
          ],
        ));
  }
}
