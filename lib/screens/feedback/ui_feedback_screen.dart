import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedBackScreen extends StatefulWidget {
  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
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
        Uri.parse(
            'http://10.7.84.229:5000/api/audio_processing?id=$documentId'),
      );
      if (response.statusCode == 200) {
        print(json.decode(response.body).toString());
        setState(() {
          final mydata = json.decode(response.body);
          _data = mydata["text"];
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
        title: Text('API Audio Fetching'),
      ),
      body: Center(
        child: Text(_data),
      ),
    );
  }
}
