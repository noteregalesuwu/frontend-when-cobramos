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
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     _launchURL();
            //   },
            //   child: const Text('Abrir en GitHub'),
            // ),
            Text(
              'Puedes abrir un issue en GitHub \n\n https://github.com/noteregalesuwu/when_cobramos/issues ',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL() async {
    const url = 'https://github.com/noteregalesuwu/when_cobramos/issues';
    // create uri from string
    final Uri uri = Uri.parse(url);
    await launchUrl(uri);

    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'No se pudo abrir $url';
    // }
  }
}
