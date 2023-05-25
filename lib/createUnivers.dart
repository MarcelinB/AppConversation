import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'universeDetailsPage.dart';

class CreateUniversePage extends StatefulWidget {
  final String token;
  final int idUser;

  CreateUniversePage(this.token, this.idUser);

  @override
  _CreateUniversePageState createState() => _CreateUniversePageState();
}

class _CreateUniversePageState extends State<CreateUniversePage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> createUniverse() async {
    final String name = _nameController.text;

    try {
      final response = await http.post(
        Uri.https('caen0001.mds-caen.yt', '/universes'),
        headers: {'Authorization': '${widget.token}'},
        body: jsonEncode({
          'name': name,
          'creator_id': widget.idUser.toString(),
        }),
      );

      if (response.statusCode == 201) {
        // Gestion du succès
        final data = json.decode(response.body);
        final universeId = data['id'];
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Succès'),
            content: const Text('L\'univers a été créé avec succès.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Ferme le dialogue
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UniverseDetailsPage(data, widget.token),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
        // Gestion des erreurs
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erreur'),
            content: const Text(
                'Une erreur s\'est produite lors de la création de l\'univers.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Erreur lors de la requête : ${e}');
      print(widget.token);
      // Gestion des erreurs de connexion
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur de connexion'),
          content: const Text('Une erreur s\'est produite lors de la connexion.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Création d\'univers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom de l\'univers',
              ),
            ),
            ElevatedButton(
              onPressed: createUniverse,
              child: const Text('Créer l\'univers'),
            ),
          ],
        ),
      ),
    );
  }
}
