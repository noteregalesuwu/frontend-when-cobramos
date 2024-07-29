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
      NotificationService().saveDebugReport(
          'Home:StateBuilder::initNotifications()', e.toString(), 'critical');
    });

    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: isLargeScreen
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pasos para activar las notificaciones push en dispositivos moviles',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 30,
                  color: Color(0xFF20D3A4),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                '1. Accede al sitio (desde donde estas leyendo esto).',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 8),
              Text(
                '2. Dale al icono de compartir en iOS (los tres puntitos en Android).',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 8),
              Text(
                '3. Busca la opcion añadir a la pantalla de inicio.',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 8),
              Text(
                '4. Accede desde tu pantalla de inicio en la aplicacion PWA creada.',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 8),
              Text(
                '5. Acepta los permisos de notificaciones.',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 8),
              Text(
                '6. Listo, ya podras recibir nuestras notificaciones.',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
