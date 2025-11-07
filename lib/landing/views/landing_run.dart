import 'package:flutter/material.dart';
import 'landing_ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC700),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const LandingUI(),
    );
  }
}

void main() {
  runApp(const MyApp());
}
