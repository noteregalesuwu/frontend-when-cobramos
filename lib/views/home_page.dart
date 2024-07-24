import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Center(
      child: Container(
        width: isLargeScreen
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Bienvenido a Uen cobramos',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 30,
            color: Color(0xFF20D3A4),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
