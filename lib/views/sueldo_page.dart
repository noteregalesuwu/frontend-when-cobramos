import 'package:flutter/material.dart';
import 'dart:async';

class SueldoPage extends StatefulWidget {
  const SueldoPage({super.key});

  @override
  _SueldoPageState createState() => _SueldoPageState();
}

class _SueldoPageState extends State<SueldoPage> {
  late DateTime _lastBusinessDay;
  late Duration _timeRemaining;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _lastBusinessDay = _calculateLastBusinessDay(DateTime.now());
    _timeRemaining = _lastBusinessDay.difference(DateTime.now());
    _startTimer();
  }

  DateTime _calculateLastBusinessDay(DateTime date) {
    DateTime lastDay = DateTime(date.year, date.month + 1, 0);
    while (lastDay.weekday == DateTime.saturday ||
        lastDay.weekday == DateTime.sunday) {
      lastDay = lastDay.subtract(const Duration(days: 1));
    }
    return lastDay;
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
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sueldo Page'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Página que te avisa cuando cuanto falta para cobrar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FractionallySizedBox(
              widthFactor: MediaQuery.of(context).size.width > 600 ? 0.5 : 1.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        'assets/img/nutria-triste-1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        'assets/img/nutria-triste-2.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        'assets/img/nutria-triste-3.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Las nutrias también están tristes 😢😢😢',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
          ],
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
