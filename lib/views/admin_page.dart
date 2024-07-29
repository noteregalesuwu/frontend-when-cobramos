import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token != null) {
        setState(() {
          _token = token;
        });
        if (kDebugMode) {
          print('Token: $token');
        }
      } else {
        if (kDebugMode) {
          print('No token found');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _sendNotification(
      String title, String message, String? url) async {
    try {
      const String apiUrl = String.fromEnvironment('API_URL', defaultValue: '');
      final response = await http.post(
        Uri.parse('$apiUrl/notifications/send_bulk'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(<String, String>{
          'title': title,
          'body': message,
          'image': url ?? '',
        }),
      );
      var responseJson = jsonDecode(response.body);
      if (responseJson['statusCode'] == 200) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Notificación Enviada'),
                content: Text(
                  responseJson.containsKey('message')
                      ? responseJson['message']
                      : 'La notificación se ha enviado correctamente',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(
                  responseJson.containsKey('message')
                      ? responseJson['message']
                      : 'No se pudo enviar la notificación',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(
                'Ocurrió un error: $e',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _showNotificationDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enviar Notificación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(fontSize: 18),
                ),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Mensaje',
                  labelStyle: TextStyle(fontSize: 18),
                ),
                style: const TextStyle(fontSize: 18),
                maxLines: 3, // Permite múltiples líneas para el mensaje
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  labelStyle: TextStyle(fontSize: 18),
                  suffixIcon: Tooltip(
                    message: 'Este campo es opcional',
                    child: Icon(Icons.info_outline, color: Colors.grey),
                  ),
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendNotification(titleController.text, messageController.text,
                    urlController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: const Color(0xFF20D3A4),
      ),
      body: Center(
        child: _token == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _showNotificationDialog,
                    child: const Text('Enviar Notificación Masiva'),
                  ),
                ],
              ),
      ),
    );
  }
}
