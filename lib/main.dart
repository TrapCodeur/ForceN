import 'package:flutter/material.dart';
import 'package:i_do/auth/verify_connexion.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Ensure this path is correct and TaskListScreen is exported from this file

void main(dynamic task) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "I DO",
      home: const AuthWrapper(),
    );
  }
}
