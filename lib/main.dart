import 'package:flutter/material.dart';
import 'package:login_app/login.dart';
import 'package:login_app/appState.dart';
import 'package:login_app/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await AppState.initialize();
  
  runApp(const ProjectApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), 
    );
  }
}
