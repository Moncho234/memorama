import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final VoidCallback onTap;

  const CardWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            '🍎', // Imágenes o emojis de las cartas
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
