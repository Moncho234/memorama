import 'package:flutter/material.dart';
import 'package:memorama/src/game_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecciona el Nivel"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [8, 10, 12].map((size) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MemoriaGame(pairCount: size)),
                );
              },
              child: Text("$size Pares"),
            );
          }).toList(),
        ),
      ),
    );
  }
}
