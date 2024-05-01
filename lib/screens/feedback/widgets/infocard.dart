import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String dialogInfo;

  const InfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.dialogInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 244, 242, 234),
      child: Container(
        padding: EdgeInsets.only(left: 12,bottom: 12,top: 2),
        width: MediaQuery.of(context).size.width / 2.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.info_outline, color: Colors.grey),
                  onPressed: () => _showInfoDialog(context, dialogInfo),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info'),
          content: Text(info),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
