import 'package:flutter/material.dart';
import 'services/apiservice.dart';
import 'showConversationPage.dart';

class CreateCharacterPage extends StatefulWidget {
  final int universeId;
  final String token;

  CreateCharacterPage(this.universeId, this.token);

  @override
  _CreateCharacterPageState createState() => _CreateCharacterPageState();
}

class _CreateCharacterPageState extends State<CreateCharacterPage> {
  TextEditingController _nameController = TextEditingController();
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService('caen0001.mds-caen.yt', widget.token);
  }

  Future<void> createCharacter() async {
    final characterName = _nameController.text;

    final data = {
      'name': characterName,
    };

    final response = await _apiService.post('/universes/${widget.universeId}/characters', data);

    if (response != null) {
      print(response);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ShowConversationPage(response, widget.token),
        ),
      );
    } else {
      print('Erreur lors de la création du personnage');
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
