import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const InfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width / 2.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
