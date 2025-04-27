import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:school_mgmt/Login.dart';
import 'package:school_mgmt/Startscreen.dart';
import 'package:school_mgmt/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Supabase.initialize(
    url: 'https://lscxfbfrltcxurrdghxz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxzY3hmYmZybHRjeHVycmRnaHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzODcwNTQsImV4cCI6MjA1Nzk2MzA1NH0.UNEmt0bwbT2d-roSRX57p_XETsXck8aRK5yG6SoKs9I',
  );

  runApp(const SchoolManagementApp());
}

class SchoolManagementApp extends StatelessWidget {
  const SchoolManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            print("User is logged in");
            return const Home(); // 🏠 Authenticated Home Screen
          } else {
            print("User is not logged in");
            return const Startscreen(); // 🔐 Unauthenticated Start Screen
          }
        },
      ),
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
      },
    );
  }
}
