import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'createUnivers.dart';
import 'UniverseDetailsPage.dart';
import 'services/apiservice.dart';

class WelcomePage extends StatefulWidget {
  final String token;
  final int idUser;

  WelcomePage(this.token, this.idUser);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<dynamic> items = [];
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService('caen0001.mds-caen.yt', widget.token);
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await _apiService.get('/universes');

      if (response != null) {
        final data = response;
        final filteredItems =
            data.where((item) => item['creator_id'] == widget.idUser).toList();
        setState(() {
          items = filteredItems;
        });
      } else {
        print('Erreur lors de la requête');
      }
    } catch (e) {
      print('Erreur de connexion : $e');
    }
  }

  void navigateToUniverseDetails(dynamic universe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => UniverseDetailsPage(universe, widget.token),
      ),
    );
  }
  
  Future<void> deleteUniverse(dynamic universe) async {
    try {
      final response = await _apiService.delete('/universes/${universe['id']}');

      if (response != null) {
        print('Univers supprimé avec succès');
        // Rafraîchir la liste des univers après la suppression
        fetchData();
      } else {
        print('Erreur lors de la suppression de l\'univers');
      }
    } catch (e) {
      print('Erreur de connexion : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Column(
        children: [
          Text(
            'Mon id utilisateur : ${widget.idUser.toString()}',
          ),
          Text(
            'Mes univers',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Creator ID: ${item['creator_id']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteUniverse(item),
                  ),
                  onTap: () => navigateToUniverseDetails(item),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CreateUniversePage(widget.token, widget.idUser),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
