import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'splash_screen.dart';

void main() => runApp(MemoriaApp());

class MemoriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
