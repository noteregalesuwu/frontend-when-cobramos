import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FooterComponent extends StatefulWidget {
  const FooterComponent({super.key});

  @override
  _FooterComponentState createState() => _FooterComponentState();
}

class _FooterComponentState extends State<FooterComponent> {
  int _visitCount = 0;

  @override
  void initState() {
    super.initState();
    _registerVisit();
    _fetchVisitCount();
  }

  Future<void> _fetchVisitCount() async {
    const apiUrl =
        String.fromEnvironment('API_URL', defaultValue: 'SOME_DEFAULT_VALUE');

    final response = await http.get(Uri.parse('$apiUrl/visitors/total'));
    if (response.statusCode == 200) {
      setState(() {
        _visitCount = json.decode(response.body)['count'];
      });
    } else {
      // Manejar error
      setState(() {
        _visitCount = 0;
      });
    }
  }

  Future<void> _registerVisit() async {
    try {
      const apiUrl =
          String.fromEnvironment('API_URL', defaultValue: 'SOME_DEFAULT_VALUE');

      if (kDebugMode) {
        print('API URL: $apiUrl');
      }

      final response =
          await http.post(Uri.parse('$apiUrl/visitors/register'), body: {
        'name': 'when_cobramos_flutter',
      });
      if (response.statusCode != 201) {
        // Manejar error
        if (kDebugMode) {
          print('Error al registrar la visita ${response.body} <===');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al registrar la visita: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF20D3A4),
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Visitas: $_visitCount 🔥',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Montserrat'),
          ),
          const SizedBox(height: 8.0),
          const Text(
            '© 2024 nutriaschambeadoras',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          const Text(
            'Version 0.0.9f-release',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
