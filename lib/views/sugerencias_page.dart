import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            GestureDetector(
              onTap: _launchURL,
              child: Text(
                'Puedes abrir un issue en GitHub \n\n https://github.com/noteregalesuwu/frontend-when-cobramos/issues',
                style: TextStyle(fontSize: 18, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _launchURL() async {
    const url = 'https://github.com/noteregalesuwu/frontend-when-cobramos/issues';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}
