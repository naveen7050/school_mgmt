import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> students = [];
  Map<String, bool> attendanceMap = {}; // studentId -> isPresent
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final date =
        DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    try {
      final studentResponse = await supabase.from('students').select('*');
      print("Supabase Response: $studentResponse");

      if (studentResponse.isNotEmpty) {
        setState(() {
          students = List<Map<String, dynamic>>.from(studentResponse);
        });
      }

      final attendanceResponse = await supabase
          .from('attendance')
          .select('*')
          .eq('attendance_date', date);

      if (attendanceResponse.isNotEmpty) {
        setState(() {
          attendanceMap = {};
          for (var record in attendanceResponse) {
            attendanceMap[record['students_id']] = record['present'];
          }
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error loading students and attendance: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submitAttendance() async {
    final date = DateTime.now().toIso8601String().substring(0, 10);

    final List<Map<String, dynamic>> records =
        attendanceMap.entries.map((entry) {
      return {
        'students_id': entry.key,
        'attendance_date': date,
        'present': entry.value,
      };
    }).toList();

    try {
      for (var record in records) {
        print('Handling attendance for: $record');

        final existingRecord = await supabase
            .from('attendance')
            .select()
            .eq('students_id', record['students_id'])
            .eq('attendance_date', record['attendance_date'])
            .maybeSingle();

        if (existingRecord != null) {
          await supabase
              .from('attendance')
              .update({'present': record['present']})
              .eq('students_id', record['students_id'])
              .eq('attendance_date', record['attendance_date']);
        } else {
          await supabase.from('attendance').insert([record]);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance submitted successfully!')),
      );
    } catch (e) {
      print("Error submitting attendance: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit attendance!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateString = "${now.day}-${now.month}-${now.year}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: const [
            Icon(Icons.check_circle_outline, size: 40, color: Colors.white),
            SizedBox(width: 10),
            Text('ATTENDANCE',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      const Text('Class: 3A',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      const Spacer(),
                      const Text('Date:',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(dateString,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  elevation: 2,
                  color: Colors.blueAccent,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text('Student Name',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white))),
                        Text('Present',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        SizedBox(width: 20),
                        Text('Absent',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final studentId = student['id'].toString();
                      final isPresent = attendanceMap[studentId] ?? false;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(student['name'],
                                      style: const TextStyle(fontSize: 16))),
                              Checkbox(
                                value: isPresent,
                                onChanged: (value) {
                                  setState(() {
                                    attendanceMap[studentId] = value ?? false;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              Checkbox(
                                value: !(isPresent),
                                onChanged: (value) {
                                  setState(() {
                                    attendanceMap[studentId] =
                                        !(value ?? false);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton.icon(
                    onPressed: submitAttendance,
                    icon: const Icon(Icons.save),
                    label: const Text('Submit Attendance'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.blue,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
