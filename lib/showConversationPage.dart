import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'conversationPage.dart';
import 'dart:convert';
import 'services/apiservice.dart'; 

class ShowConversationPage extends StatefulWidget {
  final dynamic character;
  final String token;

  ShowConversationPage(this.character, this.token);

  @override
  _ShowConversationPageState createState() => _ShowConversationPageState();
}

class _ShowConversationPageState extends State<ShowConversationPage> {
  List<dynamic> conversations = [];
  late ApiService apiService; // Instance du service ApiService

  @override
  void initState() {
    super.initState();
    apiService = ApiService('caen0001.mds-caen.yt', widget.token); // Initialiser le service ApiService
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    final response = await apiService.get('/conversations');
    if (response != null) {
      setState(() {
        conversations = response;
      });
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

  void createConversation() async {
    final response = await apiService.post('/conversations', {'character_id': widget.character['id']});
    if (response != null) {
      navigateToConversation(response);
    }
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

          if (conversation['character_id'] == widget.character['id']) {
            return ListTile(
              title: Text('Conversation ${conversation['id']}'),
              onTap: () => navigateToConversation(conversation),
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createConversation,
        child: Icon(Icons.add),
      ),
    );
  }
}
