import 'package:flutter/material.dart';
import 'services/apiservice.dart';
import 'createCharacterePage.dart';
import 'showConversationPage.dart';

class UniverseDetailsPage extends StatefulWidget {
  final dynamic universe;
  final dynamic token;

  UniverseDetailsPage(this.universe, this.token);

  @override
  _UniverseDetailsPageState createState() => _UniverseDetailsPageState();
}

class _UniverseDetailsPageState extends State<UniverseDetailsPage> {
  List<dynamic> characters = [];
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService('caen0001.mds-caen.yt', widget.token);
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    try {
      final response = await _apiService.get('/universes/${widget.universe['id']}/characters');

      if (response != null) {
        setState(() {
          characters = response;
        });
      } else {
        print('Erreur lors de la requête');
      }
    } catch (e) {
      print('Erreur de connexion : $e');
    }
  }

  void navigateToCreateCharacterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CreateCharacterPage(widget.universe['id'], widget.token),
      ),
    );
  }

  void navigateToShowConversationPage(dynamic character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ShowConversationPage(character, widget.token),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'univers'),
      ),
      body: Column(
        children: [
          Text(
            'Nom de l\'univers : ${widget.universe['name']}',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Text(
            'Liste des personnages',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: characters.length,
              itemBuilder: (BuildContext context, int index) {
                final character = characters[index];
                return ListTile(
                  title: Text(character['name']),
                  subtitle: Text('Age: ${character['age']}'),
                  onTap: () => navigateToShowConversationPage(character),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreateCharacterPage,
        child: Icon(Icons.add),
      ),
    );
  }
}
