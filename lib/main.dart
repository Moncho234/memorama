import 'package:flutter/material.dart';
import 'package:memorama/src/splash_screen.dart';

void main() => runApp(const MemoriaApp());

class MemoriaApp extends StatelessWidget {
  const MemoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
