import 'package:flutter/material.dart';

class Attendence extends StatefulWidget {
  const Attendence({super.key});

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 50,
              color: Colors.white,
            ),
            Text(
              'ATTENDENCE',
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueAccent,
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(16)),
                Text(
                  'class: 3A',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Spacer(
                  flex: 1,
                ),
                Text(
                  'Date :',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            elevation: 2,
            color: Colors.blueAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                ),
                Text(
                  'Student Name',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Spacer(),
                Text(
                  'Persent',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Absent',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: 50,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'student',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Spacer(),
                    Checkbox(
                      value: false,
                      onChanged: (value) {
                        //logic
                      },
                    ),
                    SizedBox(
                      width: 35,
                    ),
                    Checkbox(
                      value: false,
                      onChanged: (value) {
                        //logic
                      },
                    ),
                  ],
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
