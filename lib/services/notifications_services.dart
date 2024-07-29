import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<Object> getToken() async {
    try {
      //Obtener el token desde shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? localToken = prefs.getString('firebase_token');
      final existLocalToken = localToken != null && localToken.isNotEmpty;
      if (!existLocalToken) {
        if (kDebugMode) {
          print('No token found on local, requesting new token');
        }
        const vapidKey = String.fromEnvironment('VAPID_KEY', defaultValue: '');
        final fromFirebaseToken =
            await FirebaseMessaging.instance.getToken(vapidKey: vapidKey);
        //Save token in shared preferences
        prefs.setString('firebase_token', fromFirebaseToken.toString());
        return fromFirebaseToken.toString();
      } else {
        if (kDebugMode) {
          print('Token obtenido desde local: $localToken');
        }
        return localToken.toString();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener el token: $e');
      }
      ('NotificationsService::getToken()', e.toString(), 'critical');
      return '';
    }
  }

  Future<String> registerToken(String token) async {
    try {
      const apiUrl = String.fromEnvironment('API_URL', defaultValue: '');
      final response =
          await http.post(Uri.parse('$apiUrl/notifications/register'), body: {
        'token': token,
      });
      if (response.statusCode == 201) {
        return 'Token $token registrado correctamente';
      } else {
        return 'Error al registrar el token $token';
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
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      saveDebugReport('NotificationsService::authStatus',
          'No se tienen los permisos requeridos', 'debug');
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

      // return;
    }

    Object token;

    saveDebugReport('NotificationsService::currentPlatform',
        DefaultFirebaseOptions.currentPlatform.toString(), 'debug');

    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
      try {
        saveDebugReport('NotificationsService::retrievingTokenFromTarget',
            'Obteniendo token', 'debug');
        token = await getToken();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        saveDebugReport('NotificationService::initNotifications()::catch',
            e.toString(), 'error');
        token = '';
      }
    } else {
      saveDebugReport('NotificationsService::currentPlatformElse',
          'No es una plataforma web', 'debug');
      //Only for web, if not web abort
      return;
    }

    try {
      saveDebugReport('NotificationsService::registerTokenIntoAPI',
          'Guardando este token:$token', 'debug');
      final registerResult =
          await NotificationService().registerToken(token.toString());
      await saveDebugReport('NotificationsService::registerTokenIntoAPI::post',
          registerResult.toString(), 'debug');
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
      // Send report to http endpoint
      saveDebugReport('NotificationService::registerTokenIntoAPI:catch',
          e.toString(), 'error');
    }
  }

  Future<void> saveDebugReport(
      String module, String errorMessage, String errorLevel) async {
    try {
      const apiUrl = String.fromEnvironment('API_URL', defaultValue: '');
      final response = await http.post(
        Uri.parse('$apiUrl/debug_report/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'module': module,
          'error_message': errorMessage,
          'error_level': errorLevel,
        }),
      );
      var responseJson = jsonDecode(response.body);
      if (responseJson['statusCode'] == 200) {
        if (kDebugMode) {
          print('Reporte enviado');
        }
      } else {
        if (kDebugMode) {
          print('Error al enviar el reporte');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al enviar el reporte: $e');
      }
    }
  }
}
