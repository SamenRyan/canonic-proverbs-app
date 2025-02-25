import 'package:flutter/material.dart';
// import 'q_home.dart';
import 'splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuotApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xff1C1934),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xff1C1934), // Main primary color
          secondary: Colors.pink, // Accent color
        ),
      ),
      home: const SplashScreen(),
    );
  }
}