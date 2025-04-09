import 'package:flutter/material.dart';

class ExamRoutine extends StatelessWidget {
  const ExamRoutine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Routine'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildExamCard(
              subject: "Mathematics",
              date: "10-Apr-2025",
              time: "10:00 AM - 1:00 PM",
              room: "Room 101",
            ),
            SizedBox(height: 16),
            _buildExamCard(
              subject: "Science",
              date: "12-Apr-2025",
              time: "10:00 AM - 1:00 PM",
              room: "Room 102",
            ),
            SizedBox(height: 16),
            _buildExamCard(
              subject: "English",
              date: "14-Apr-2025",
              time: "10:00 AM - 1:00 PM",
              room: "Room 103",
            ),
            SizedBox(height: 16),
            _buildExamCard(
              subject: "Social Studies",
              date: "16-Apr-2025",
              time: "10:00 AM - 1:00 PM",
              room: "Room 104",
            ),
            SizedBox(
              height: 16,
            ),
            _buildExamCard(
              subject: "Hindi",
              date: "18-Apr-2025",
              time: "10:00 AM - 1:00 PM",
              room: "Room 105",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard({
    required String subject,
    required String date,
    required String time,
    required String room,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                SizedBox(width: 6),
                Text(date),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[700]),
                SizedBox(width: 6),
                Text(time),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.room, size: 16, color: Colors.grey[700]),
                SizedBox(width: 6),
                Text(room),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
