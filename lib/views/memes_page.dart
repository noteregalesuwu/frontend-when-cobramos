import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MemesPage extends StatefulWidget {
  const MemesPage({super.key});

  @override
  _MemesPageState createState() => _MemesPageState();
}

class _MemesPageState extends State<MemesPage> {
  final List<Map<String, String>> memesProvider = [
    {'provider': 'MemesEspanol', 'name': 'Memes en Español'},
    {'provider': 'ProgrammerHumor', 'name': 'Programmer Humor'},
  ];

  String selectedProvider = 'MemesEspanol';

  Future<List<String>> fetchMemes() async {
    try {
      final response = await http
          .get(Uri.parse('https://meme-api.com/gimme/$selectedProvider/50'))
          .catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> memes = data['memes'];
        return memes.map((meme) => meme['url'] as String).toList();
      } else {
        throw Exception('Failed to load memes');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  void showImageModal(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Memes'),
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: selectedProvider,
              onChanged: (String? newValue) {
                setState(() {
                  selectedProvider = newValue!;
                });
              },
              items: memesProvider.map<DropdownMenuItem<String>>(
                  (Map<String, String> category) {
                return DropdownMenuItem<String>(
                  value: category['provider'],
                  child: Text(category['name']!),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchMemes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No memes found'));
          } else {
            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;
                if (constraints.maxWidth < 600) {
                  crossAxisCount = 1;
                } else if (constraints.maxWidth < 1200) {
                  crossAxisCount = 4;
                } else {
                  crossAxisCount = 6;
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () =>
                          showImageModal(context, snapshot.data![index]),
                      child: ImageCard(imageUrl: snapshot.data![index]),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String imageUrl;

  const ImageCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Image.network(imageUrl),
    );
  }
}
