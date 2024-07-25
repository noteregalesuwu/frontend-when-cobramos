import 'package:flutter/material.dart';
/**
 * Usamos la api de html para abrir un enlace en una nueva pestaña. de manera excepcional por ahora
 * @see https://api.flutter.dev/flutter/dart-html/html-library.html
 * 
 */

import 'dart:html' as html;

class SugerenciasPage extends StatelessWidget {
  const SugerenciasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugerencias'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cualquier sugerencia o cambio es bienvenido.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Puedes abrir un issue en GitHub \n\n',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: _launchURL,
              child: Text(
                'Ver en GitHub',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  static void _launchURL() async {
    const url =
        'https://github.com/noteregalesuwu/frontend-when-cobramos/issues';
    html.window.open(url, 'GitHub');
  }
}
