import 'package:flutter/material.dart';
import 'dart:async';
import 'card_widget.dart';

class MemoriaGame extends StatefulWidget {
  @override
  _MemoriaGameState createState() => _MemoriaGameState();
}

class _MemoriaGameState extends State<MemoriaGame> {
  int aciertos = 0;
  int movimientos = 0;
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Juego de Memoria 🥲'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  return CardWidget(
                    onTap: () {
                      setState(() {
                        movimientos++;
                        // Agrega la lógica para aciertos aquí
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildStatistics(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aciertos: $aciertos 😍',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Excelente. Tu tiempo fue: $_seconds segundos',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Movimientos: $movimientos 🤯😎',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
