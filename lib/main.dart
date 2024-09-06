import 'package:flutter/material.dart';
import 'login.dart'; // Pastikan import sesuai dengan lokasi file login.dart
import 'dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMKN 4 Bogor',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => Dashboard(),
        '/login': (context) =>
            LoginScreen(), // Replace with your actual login screen widget
      },
    );
  }
}
