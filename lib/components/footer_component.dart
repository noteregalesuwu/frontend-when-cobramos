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
    _fetchVisitCount();
    _registerVisit();
  }

  Future<void> _fetchVisitCount() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/visitors/total'));
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
    final response = await http
        .post(Uri.parse('http://localhost:3000/visitors/register'), body: {
      'name': 'when_cobramos_flutter',
    });
    if (response.statusCode != 200) {
      // Manejar error
      print('Error al registrar la visita');
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
            'Visitas: $_visitCount',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Montserrat'),
          ),
          const SizedBox(height: 8.0),
          const Text(
            '© 2024 When Cobramos',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
