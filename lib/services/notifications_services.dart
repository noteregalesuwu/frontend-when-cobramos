import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class NotificationService {
  Future<void> listenNotifications() async {
    FirebaseMessaging.onMessage.listen(_showFlutterNotification);
  }

  void _showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      Fluttertoast.showToast(
        msg: notification.body ?? 'Tienes una nueva notificación',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFF20D3A4),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<String> getToken() async {
    try {
      return await FirebaseMessaging.instance.getToken() ?? '';
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener el token: $e');
      }
      return '';
    }
  }

  Future<String> registerToken(String token) async {
    try {
      final apiUrl = dotenv.env['API_URL'] ?? '';
      final response =
          await http.post(Uri.parse('$apiUrl/notifications/register'), body: {
        'token': token,
      });
      if (response.statusCode == 201) {
        return 'Token registrado correctamente';
      } else {
        return 'Error al registrar el token';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al registrar el token: $e');
      }
      return 'Error al registrar el token';
    }
  }

  Future<bool> requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> initNotifications(BuildContext context) async {
    // await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    WidgetsFlutterBinding.ensureInitialized();

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permisos de notificaciones'),
            content:
                const Text('Activa las notificaciones para recibir alertas'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  requestPermission();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );

      return;
    }

    final vapidKey = dotenv.env['VAPID_KEY'] ?? '';

    if (kDebugMode) {
      print('Vapid Key: $vapidKey');
    }

    String? token;

    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
      try {
        token = await messaging.getToken(
          vapidKey: vapidKey,
        );
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      token = await messaging.getToken();
    }

    if (kDebugMode) {
      print('Registration Token=$token');
    }

    /**
   * Register token
   */
    try {
      NotificationService().registerToken(token ?? '');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificaciones activadas'),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
          closeIconColor: Colors.white,
          showCloseIcon: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }
  }
}
