import 'package:flutter/material.dart';
import 'dart:convert';
import 'services/apiservice.dart';
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
  late ApiService _apiService = ApiService('caen0001.mds-caen.yt', widget.token);

  Future<void> createUniverse() async {
    final String name = _nameController.text;

    try {
      final response = await _apiService.post('/universes', {
        'name': name,
        'creator_id': widget.idUser.toString(),
      });

      if (response != null) {
        final universeId = response['id'];
        print(response['id']);
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Succès'),
            content: const Text('L\'univers a été créé avec succès.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UniverseDetailsPage(universeId, widget.token),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Une erreur s\'est produite lors de la création de l\'univers.'),
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
