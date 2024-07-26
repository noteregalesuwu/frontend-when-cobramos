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

  Future<void> initNotifications() async {
    await dotenv.load(fileName: ".env");
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
