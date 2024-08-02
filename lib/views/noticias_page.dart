import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Noticia {
  static String apiUrl = const String.fromEnvironment('API_URL',
      defaultValue: 'SOME_DEFAULT_VALUE');
  final int id;
  final String title;
  final String date;
  final String url;
  final String image;
  final String source;
  final String hashId;

  Noticia({
    required this.id,
    required this.title,
    required this.date,
    required this.url,
    required this.image,
    required this.source,
    required this.hashId,
  });

  String get imageUrl => '$apiUrl/news/proxy_images/$id';
  String get dateParsed {
    DateTime parsedDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
    return formatter.format(parsedDate);
  }

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sin título',
      date: json['date'] ?? 'Sin fecha',
      url: json['url'] ?? 'Sin URL',
      image: json['image'] ?? 'Sin imagen',
      source: json['source'] ?? 'Sin fuente',
      hashId: json['hash_id'] ?? 'Sin hashId',
    );
  }
}

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({super.key});

  @override
  NoticiasPageState createState() => NoticiasPageState();
}

class NoticiasPageState extends State<NoticiasPage> {
  late Future<List<Noticia>> futurasNoticias;

  @override
  void initState() {
    super.initState();
    futurasNoticias = fetchNoticias();
  }

  Future<void> _showNoticiaModal(BuildContext context, String noticiaId) async {
    const apiUrl =
        String.fromEnvironment('API_URL', defaultValue: 'SOME_DEFAULT_VALUE');
    final response = await http
        .post(Uri.parse('$apiUrl/news/get_new_by_id'), body: {'id': noticiaId});

    if (response.statusCode == 200) {
      final noticia = json.decode(response.body);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double dialogWidth = constraints.maxWidth > 600
                    ? constraints.maxWidth * 0.5
                    : constraints.maxWidth;

                return Container(
                  width: dialogWidth,
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Noticia'),
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            noticia['title'],
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              '$apiUrl/news/proxy_images/${noticia['id']}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                          ),
                          Text(noticia['body'],
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    } else {
      // Manejar error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No se pudo cargar la noticia.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<Noticia>> fetchNoticias() async {
    const apiUrl =
        String.fromEnvironment('API_URL', defaultValue: 'SOME_DEFAULT_VALUE');
    if (kDebugMode) {
      print('API_URL: $apiUrl/news/get_news');
    }
    final response = await http.get(Uri.parse('$apiUrl/news/get_news'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((noticia) => Noticia.fromJson(noticia)).toList();
    } else {
      if (kDebugMode) {
        return [
          Noticia(
            id: 0,
            title: 'Error',
            date: '2021-10-10',
            url: 'https://www.google.com',
            image: 'https://www.google.com',
            source: 'Error',
            hashId: 'Error',
          )
        ];
      } else {
        return [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
      ),
      body: FutureBuilder<List<Noticia>>(
        future: futurasNoticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay noticias disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final noticia = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(noticia.title),
                    subtitle: Text(noticia.dateParsed.toString()),
                    trailing: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          noticia.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
                    onTap: () =>
                        _showNoticiaModal(context, noticia.id.toString()),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
