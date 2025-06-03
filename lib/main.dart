import 'package:cuarta2proyecto/screens/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:cuarta2proyecto/screens/auth/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Universidad del Koala Pensante',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200], // Color de fondo general
      ),
      home: SignInScreen(),
    );
  }
}
