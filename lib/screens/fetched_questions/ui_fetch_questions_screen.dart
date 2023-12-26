import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeneratedQuestionsScreen extends StatefulWidget {
  @override
  _GeneratedQuestionsScreenState createState() =>
      _GeneratedQuestionsScreenState();
}

class _GeneratedQuestionsScreenState extends State<GeneratedQuestionsScreen> {
  String _data = '';
  @override
  void initState() {
    super.initState();
    dynamic arguments = Get.arguments;
    String documentId = arguments["id"];
    print(documentId);
    fetchData(documentId);
  }

  Future<void> fetchData(String documentId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/extract?id=$documentId'),
      );
      if (response.statusCode == 200) {
        print(json.decode(response.body).toString());
        setState(() {
          final mydata = json.decode(response.body);
          _data = mydata['generated_questions'];
        });
      } else {
        setState(() {
          _data = 'Failed to load data';
        });
      }
    } catch (e) {
      setState(() {
        _data = 'Failed to load data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Data Fetching'),
      ),
      body: Center(
        child: Text(_data),
      ),
    );
  }
}
