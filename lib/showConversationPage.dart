import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'conversationPage.dart';
import 'dart:convert';

class ShowConversationPage extends StatefulWidget {
  final dynamic character;
  final String token;

  ShowConversationPage(this.character, this.token);

  @override
  _ShowConversationPageState createState() => _ShowConversationPageState();
}

class _ShowConversationPageState extends State<ShowConversationPage> {
  List<dynamic> conversations = [];

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    try {
      final response = await http.get(
        Uri.https('caen0001.mds-caen.yt', '/conversations'),
        headers: {'Authorization': '${widget.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          conversations = jsonDecode(response.body);
        });
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
        // Gérer les erreurs de récupération des conversations
      }
    } catch (e) {
      print('Erreur de connexion : $e');
      // Gérer les erreurs de connexion
    }
  }

  void navigateToConversation(dynamic conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ConversationPage(conversation, widget.token, widget.character['name']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterName = widget.character['name'] ?? 'Personnage inconnu';

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation avec $characterName'),
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (BuildContext context, int index) {
          final conversation = conversations[index];

          // Vérifier si le character_id correspond au personnage actuel
          if (conversation['character_id'] == widget.character['id']) {
            return ListTile(
              title: Text('Conversation ${conversation['id']}'),
              onTap: () => navigateToConversation(conversation),
            );
          }

          return Container(); // Retourner un conteneur vide si le personnage ne correspond pas
        },
      ),
    );
  }
}


