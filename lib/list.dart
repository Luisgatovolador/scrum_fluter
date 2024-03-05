import 'dart:convert';
import 'package:flutter/material.dart';
import 'item.dart';

class JsonListViewScreen extends StatefulWidget {
  const JsonListViewScreen({Key? key}) : super(key: key);

  @override
  _JsonListViewScreenState createState() => _JsonListViewScreenState();
}

class _JsonListViewScreenState extends State<JsonListViewScreen> {
  late Future<List<ScrumItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = loadItems();
  }

  Future<List<ScrumItem>> loadItems() async {
    try {
      String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/data_scrum.json');
      List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => ScrumItem.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error cargando el archivo JSON: $e');
      throw Exception('No se pudieron cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ScrumItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 160, 124, 151)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<ScrumItem>? items = snapshot.data;
            return ListView.builder(
              itemCount: items!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Color.fromARGB(255, 198, 153, 196),
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ExpansionTile(
                    title: Text(
                      items[index].name,
                      style: TextStyle(color: Color.fromARGB(255, 134, 80, 145)),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Descripción:',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              items[index].description,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ejemplo:',
                              style: TextStyle(
                                color: Color.fromARGB(255, 75, 43, 104),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              items[index].example,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 8),
                            // Agregamos la imagen desde la URL
                            Image.network(
                              items[index].image,
                              width: 200, // Ancho de la imagen al ancho de la pantalla
                            ),
                          ],
                        ),
                      ),
                    ],
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
