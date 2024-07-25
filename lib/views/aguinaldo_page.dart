import 'package:flutter/material.dart';
import 'dart:async';

class AguinaldoPage extends StatefulWidget {
  const AguinaldoPage({super.key});

  @override
  _AguinaldoPageState createState() => _AguinaldoPageState();
}

class _AguinaldoPageState extends State<AguinaldoPage> {
  late DateTime _lastBusinessDay;
  late Duration _timeRemaining;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _lastBusinessDay = DateTime(2024, 12, 16);
    _timeRemaining = _lastBusinessDay.difference(DateTime.now());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining = _lastBusinessDay.difference(DateTime.now());
        if (_timeRemaining.isNegative) {
          _timer.cancel();
        }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen =
        screenWidth > 600; // Define un umbral para pantallas grandes

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 32),
              const Text(
                'Página que te avisa cuando cuanto falta para el Aguinaldo',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        30.0), // Ajusta el radio según sea necesario
                    child: Image.asset('assets/img/nutria-triste.jpg',
                        width: 200, height: 200),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Porque no puedo adelantar el tiempo?', // Aquí va la descripción
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              FractionallySizedBox(
                widthFactor: isLargeScreen ? 0.5 : 1.0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeCard(_timeRemaining.inDays, 'Días'),
                      const SizedBox(width: 8),
                      _buildTimeCard(
                          _timeRemaining.inHours.remainder(24), 'Horas'),
                      const SizedBox(width: 8),
                      _buildTimeCard(
                          _timeRemaining.inMinutes.remainder(60), 'Minutos'),
                      const SizedBox(width: 8),
                      _buildTimeCard(
                          _timeRemaining.inSeconds.remainder(60), 'Segundos'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {
              //         Navigator.pushNamed(context, '/memes');
              //       },
              //       child: const Text('Memes'),
              //     ),
              //     const SizedBox(width: 16),
              //     ElevatedButton(
              //       onPressed: () {
              //         Navigator.pushNamed(context, '/sueldo');
              //       },
              //       child: const Text('Sueldo'),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard(int time, String label) {
    return Column(
      children: [
        Text(
          time.toString().padLeft(2, '0'),
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 30,
            color: Color(0xFF20D3A4),
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Color(0xFF20D3A4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
