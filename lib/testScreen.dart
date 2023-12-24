import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiScreen extends StatefulWidget {
  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  String _data = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      http.Response response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api'),
      );

      print(response.body);
      if (response.statusCode == 200) {
        print(json.decode(response.body).toString());
        setState(() {
          final mydata = json.decode(response.body);
          _data = mydata['message'];
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
