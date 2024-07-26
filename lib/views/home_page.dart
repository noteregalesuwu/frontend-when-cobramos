import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:when_cobramos_flutter/services/notifications_services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    NotificationService()
        .initNotifications(context)
        .then((value) => print('Notificaciones inicializadas'))
        .catchError((e) {
      if (kDebugMode) {
        print('Error al inicializar las notificaciones: $e');
      }
    });

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
