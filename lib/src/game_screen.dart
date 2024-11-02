import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';
import 'dart:async';
import 'card_widget.dart';
import 'db_helper.dart';

class MemoriaGame extends StatefulWidget {
  final int pairCount; // Permite establecer el tamaño de los pares

  const MemoriaGame({Key? key, required this.pairCount}) : super(key: key);

  @override
  _MemoriaGameState createState() => _MemoriaGameState();
}

class _MemoriaGameState extends State<MemoriaGame> {
  int? _soundId; // ID del sonido cargado
  late Soundpool _soundpool; // Controlador de sonido
  int aciertos = 0;
  int movimientos = 0;
  late Timer _timer;
  int _seconds = 0;
  bool gameFinished = false;

  // Lista de emojis para las cartas
  final List<String> baseEmojis = [
    '🍊',
    '🍒',
    '🍓',
    '🍉',
    '🥦',
    '🥑',
    '🌽',
    '🍌',
    '🍇',
    '🥥',
    '🍍',
    '🍋'
  ];

  late List<String> emojis; // Lista de emojis en el juego
  List<bool> visibleEmojis = []; // Lista para mostrar/ocultar los emojis
  int? firstSelectedIndex; // Índice de la primera carta seleccionada
  int? bestRecord; // Variable para almacenar el mejor récord

  @override
  void initState() {
    super.initState();
    _soundpool = Soundpool(); // Inicializa Soundpool
    _loadSound();
    _startTimer();

    // Configuración de los emojis y estado inicial de visibilidad
    emojis = List.from(baseEmojis.sublist(0, widget.pairCount))
      ..addAll(List.from(baseEmojis.sublist(0, widget.pairCount)))
      ..shuffle();
    visibleEmojis = List<bool>.filled(emojis.length, false);

    _loadBestRecord(); // Cargar el mejor récord al iniciar
  }

  // Cargar el sonido
  Future<void> _loadSound() async {
    _soundId = await _soundpool.loadUri(
        'assets/sound.mp3'); 
  }

  // Reproducir el sonido
  void _playSound() {
    if (_soundId != null) {
      _soundpool.play(
          _soundId!); 
    }
  }

  // Cargar el mejor récord desde la base de datos
  Future<void> _loadBestRecord() async {
    final record = await DBHelper.getBestScore(widget.pairCount);
    setState(() {
      bestRecord = record; // Asigna el récord cargado
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!gameFinished) {
        // Solo actualiza si el juego no ha terminado
        setState(() {
          _seconds++;
        });
      }
    });
  }

  Future<void> _endGame() async {
    setState(() {
      gameFinished = true; // Cambia el estado del juego a terminado
    });
    _timer.cancel(); // Detener el temporizador

    final bestTime = await DBHelper.getBestScore(widget.pairCount);

    // Guardar el tiempo si es un nuevo récord
    if (bestTime == null || _seconds < bestTime) {
      await DBHelper.saveScore(widget.pairCount, _seconds);
      _loadBestRecord(); // Cargar el nuevo récord
      _showNewRecordMessage(); // Mostrar mensaje de nuevo récord
    }

    // Mostrar el diálogo de finalización del juego
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Juego Terminado"),
        content: Text("¡Felicidades! Tiempo: $_seconds segundos"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame(); // Reiniciar el juego
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showNewRecordMessage() {
    final snackBar = SnackBar(
      content: const Text("¡Nuevo récord!"),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); // Mostrar SnackBar
  }

  void _resetGame() {
    setState(() {
      aciertos = 0;
      movimientos = 0;
      _seconds = 0;
      gameFinished = false;
      visibleEmojis = List<bool>.filled(emojis.length, false);
      emojis.shuffle(); // Barajar nuevamente los emojis
      firstSelectedIndex = null; // Reinicia el índice seleccionado
      _startTimer(); // Reinicia el temporizador
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _soundpool.release(); // Libera el Soundpool cuando no se necesite
    super.dispose();
  }

  void _handleCardTap(int index) {
    if (visibleEmojis[index] || gameFinished)
      return; // Evita acciones si el juego ya terminó

    setState(() {
      visibleEmojis[index] = true; // Muestra el emoji seleccionado
      movimientos++; // Incrementa movimientos
    });

    if (firstSelectedIndex == null) {
      firstSelectedIndex = index; // Guarda el primer índice seleccionado
    } else {
      final firstIndex = firstSelectedIndex!; // Obtiene el primer índice
      firstSelectedIndex = null; // Reinicia el índice seleccionado

      if (emojis[firstIndex] == emojis[index]) {
        // Si coinciden
        setState(() {
          aciertos++; // Aumenta aciertos
          _playSound(); // Reproduce sonido al hacer coincidir un par
        });

        // Verifica si se han encontrado todos los pares
        if (aciertos == widget.pairCount) {
          _endGame(); // Finaliza el juego cuando se encuentren todos los pares
        }
      } else {
        // Si no coinciden, oculta las cartas después de un pequeño delay
        Future.delayed(const Duration(seconds: 1), () {
          if (!gameFinished) {
            // Solo oculta si el juego no ha terminado
            setState(() {
              visibleEmojis[firstIndex] = false; // Oculta el primer emoji
              visibleEmojis[index] = false; // Oculta el segundo emoji
            });
          }
        });
      }
    }
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
                itemCount: emojis.length,
                itemBuilder: (context, index) {
                  return CardWidget(
                    emoji: visibleEmojis[index]
                        ? emojis[index]
                        : '', // Mostrar emoji o vacío
                    onTap: () =>
                        _handleCardTap(index), // Manejar selección de carta
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
            'Tiempo: $_seconds segundos',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Movimientos: $movimientos 🤯😎',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Récord: ${bestRecord != null ? bestRecord : "N/A"} 🏆', // Mostrar el récord
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
