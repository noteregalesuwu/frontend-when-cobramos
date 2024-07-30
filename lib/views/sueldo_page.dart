import 'package:confetti/confetti.dart';
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
  late ConfettiController _confettiController;
  final isToday = false;

  @override
  void initState() {
    super.initState();
    _lastBusinessDay = _calculateLastBusinessDay(DateTime.now());
    _timeRemaining = _lastBusinessDay.difference(DateTime.now());
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));

    _startTimer();
  }

  DateTime _calculateLastBusinessDay(DateTime date) {
    DateTime lastDay = DateTime(date.year, date.month + 1, 0);
    while (lastDay.weekday == DateTime.saturday ||
        lastDay.weekday == DateTime.sunday) {
      lastDay = lastDay.subtract(const Duration(days: 1));
    }
    DateTime result = DateTime(lastDay.year, lastDay.month, lastDay.day, 21, 0);
    return result;
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
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    // SI quedan 0 dias y 12 horas lanzar confetti y activar el modo de hoy se cobra XD
    int remainingHoursToday =
        _timeRemaining.inHours - (_timeRemaining.inDays * 24);
    bool isPayDay = _timeRemaining.inDays == 0 && remainingHoursToday <= 12;
    if (isPayDay) {
      _confettiController.play();
    }

    return Scaffold(
      body: Stack(
        children: [
          if (isPayDay)
            Container(
              // color: Colors.green,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF20D3A4),
                    Color(0xFF2D9CDB),
                  ],
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¡Es hoy, es hoy!!!',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: FractionallySizedBox(
                        widthFactor: isLargeScreen ? 0.5 : 1.0,

                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.asset(
                              'assets/img/nutria-feliz.jpeg',
                              fit: BoxFit.cover,
                            )),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isPayDay)
                    const Text(
                      'Página que te avisa cuanto falta para cobrar',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 16),
                  if (!isPayDay)
                    FractionallySizedBox(
                      widthFactor:
                          MediaQuery.of(context).size.width > 600 ? 0.5 : 1.0,
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
                                'assets/img/nutria-triste.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (!isPayDay)
                    const Text(
                      'Las nutrias también están tristes 😢😢😢',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 32),
                  if (!isPayDay)
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
                                _timeRemaining.inMinutes.remainder(60),
                                'Minutos'),
                            const SizedBox(width: 8),
                            _buildTimeCard(
                                _timeRemaining.inSeconds.remainder(60),
                                'Segundos'),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -3.14,
              maxBlastForce: 50,
              minBlastForce: 10,
              emissionFrequency: 0.03,
              numberOfParticles: 10,
              shouldLoop: true,
              gravity: 0.1,
              blastDirectionality: BlastDirectionality.explosive,
            ),
          ),
        ],
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
