import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String emoji;
  final VoidCallback onTap;

  const CardWidget({
    Key? key,
    required this.emoji,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            emoji.isNotEmpty
                ? emoji
                : '❓', // Muestra un "?" cuando el emoji está oculto
            style: const TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}
