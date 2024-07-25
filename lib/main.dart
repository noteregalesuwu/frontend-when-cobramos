import 'package:flutter/material.dart';
import 'package:when_cobramos_flutter/views/aguinaldo_page.dart';
import 'package:when_cobramos_flutter/views/home_page.dart';
import 'package:when_cobramos_flutter/views/informaciones_page.dart';
import 'package:when_cobramos_flutter/views/memes_page.dart';
import 'package:when_cobramos_flutter/views/sueldo_page.dart';
import 'package:when_cobramos_flutter/views/sugerencias_page.dart';
import 'package:when_cobramos_flutter/components/footer_component.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(
        context); // Cierra el drawer después de seleccionar una opción
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Pantallas grandes
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              backgroundColor: const Color(0xFF20D3A4),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Inicio', icon: Icon(Icons.home)),
                  Tab(text: 'Sueldo', icon: Icon(Icons.attach_money)),
                  Tab(text: 'Aguinaldo', icon: Icon(Icons.attach_money)),
                  Tab(text: 'Memes', icon: Icon(Icons.mood)),
                  Tab(text: 'Informaciones', icon: Icon(Icons.info)),
                  Tab(text: 'Sugerencias', icon: Icon(Icons.feedback)),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      HomePage(),
                      SueldoPage(),
                      AguinaldoPage(),
                      MemesPage(),
                      InformacionesPage(),
                      SugerenciasPage(),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: FooterComponent(),
                ),
              ],
            ),
          );
        } else {
          // Pantallas pequeñas
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              backgroundColor: const Color(0xFF20D3A4),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(0xFF20D3A4),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/img/nutria-chambeadora.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Inicio'),
                    onTap: () => _onItemTapped(0),
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Sueldo'),
                    onTap: () => _onItemTapped(1),
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Aguinaldo'),
                    onTap: () => _onItemTapped(2),
                  ),
                  ListTile(
                    leading: const Icon(Icons.mood),
                    title: const Text('Memes'),
                    onTap: () => _onItemTapped(3),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Informaciones'),
                    onTap: () => _onItemTapped(4),
                  ),
                  ListTile(
                    leading: const Icon(Icons.feedback),
                    title: const Text('Sugerencias'),
                    onTap: () => _onItemTapped(5),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: const [
                      HomePage(),
                      SueldoPage(),
                      AguinaldoPage(),
                      MemesPage(),
                      InformacionesPage(),
                      SugerenciasPage(),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: FooterComponent(),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    title: 'Uen Cobramos',
    themeMode: ThemeMode.system,
    home: MyHomePage(title: 'Uen Cobramos'),
  ));
}
