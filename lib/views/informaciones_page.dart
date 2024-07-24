import 'package:flutter/material.dart';

class InformacionesPage extends StatelessWidget {
  const InformacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen =
        screenWidth > 600; // Define un umbral para pantallas grandes

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Informacion del sitio',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 30,
                color: Color(0xFF20D3A4),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600, // Ancho máximo del párrafo
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Esta página web fue creada como un meme.\n\n'
                  'Se tiene en cuenta que la hora de cobro para el contador es a las 21:00 horas, y el día de cobro es el último día hábil de cada mes. El aguinaldo, aunque no sabemos cuándo se paga en realidad, le hemos puesto el 16 de diciembre por diversión.\n\n'
                  'En el botón de sugerencias pueden enviar cualquier cosa que deseen que se agregue o modifique, pero evitando contenido promocional o spam.\n\n'
                  'Gracias por visitar el sitio y ¡que vivan las nutrias!',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                double imageWidth = isLargeScreen
                    ? 300 // Máximo 300 píxeles en pantallas grandes
                    : constraints.maxWidth *
                        0.5; // Máximo 50% del ancho total en pantallas pequeñas
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: imageWidth,
                  ),
                  child: Image.asset(
                    'assets/img/nutria-triste.jpg',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            const Text(
              'Lic. Nutriologo',
            ),
          ],
        ),
      ),
    );
  }
}
