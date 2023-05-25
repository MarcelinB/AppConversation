import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateCharacterPage extends StatefulWidget {
  final int universeId;
  final String token;

  CreateCharacterPage(this.universeId, this.token);

  @override
  _CreateCharacterPageState createState() => _CreateCharacterPageState();
}

class _CreateCharacterPageState extends State<CreateCharacterPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  Future<void> createCharacter() async {
    try {
      final response = await http.post(
        Uri.https('caen0001.mds-caen.yt', '/universes/${widget.universeId}/characters'),
        headers: {'Authorization': '${widget.token}', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text
        }),
      );

      if (response.statusCode == 201) {
        // Personnage créé avec succès
        Navigator.pop(context, true); // Retourne à la page précédente en indiquant que le personnage a été créé
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
        // Gérer les erreurs de création du personnage
      }
    } catch (e) {
      print('Erreur de connexion : $e');
      // Gérer les erreurs de connexion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Création de personnage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
              ),
            ),
          
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: createCharacter,
              child: Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
