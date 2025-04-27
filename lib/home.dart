import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_mgmt/Attendence.dart';
import 'package:school_mgmt/Exam_routine.dart';
import 'package:school_mgmt/Homework.dart';
import 'package:school_mgmt/Notice_events.dart';
import 'package:school_mgmt/Result.dart';
import 'package:school_mgmt/Solution.dart';
import 'package:school_mgmt/Startscreen.dart';
import 'package:school_mgmt/contact.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text("Menu"),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Startscreen(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text("Profile Of School"),
              // add on pressed button here and redirect it to a new page
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              // add on pressed button here and redirect it to a new page
            ),
            ListTile(
              leading: Icon(Icons.emergency),
              title: Text("Emergency contacts"),
              // add on pressed button here and redirect it to a new page
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(800, 500),
                  bottomRight: Radius.elliptical(800, 500),
                ),
              ),
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  padding: EdgeInsets.only(right: 320),
                  visualDensity: VisualDensity(vertical: 2),
                  constraints: BoxConstraints(),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.blueAccent,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        "WELCOME MESSAGE -> ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Empowering students, teachers, and parents with a smarter way to stay connected, informed, and inspired every day",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            // button icons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing:
                    10, //managing space between each item horizontally.
                mainAxisSpacing:
                    25, //managing space between each item vertically.
                shrinkWrap:
                    true, // prevent from taking extra space used by gridview or we can say that adjust content it's height a/q to content.
                physics:
                    NeverScrollableScrollPhysics(), //prevent from gridview scrolling functionalities. after it gridview behave as a static layout.
                children: [
                  _buildButton(context, Icons.check_circle_outline,
                      "Attendance", Attendance()),
                  _buildButton(
                      context, Icons.home_work, "Homework", Homework()),
                  _buildButton(context, Icons.description, "Result", Result()),
                  _buildButton(
                      context, Icons.schedule, "Exam Routine", ExamRoutine()),
                  _buildButton(
                      context, Icons.lightbulb_outline, "Solution", Solution()),
                  _buildButton(
                      context, Icons.event, "Notice & Events", Notice_Events()),
                  _buildButton(
                      context, Icons.person_add, "Add Accounts", Contact()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildButton(
    BuildContext context, IconData icon, String label, Widget screen) {
  return GestureDetector(
    onTap: () {
// buttons
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.blue,
          ),
          SizedBox(
            height: 8,
          ),
          Text(label)
        ],
      ),
    ),
  );
}
