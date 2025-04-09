import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.description,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'RESULT',
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildResultCard("first terminal"),
            SizedBox(height: 10),
            _buildResultCard("second terminal"),
            SizedBox(height: 10),
            _buildResultCard("Third terminal")
          ],
        ),
      ),
    );
  }
}

Widget _buildResultCard(String title) {
  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 40,
            color: Colors.grey[300], // Placeholder for result content
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "PUBLISH",
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
