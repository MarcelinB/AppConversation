import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversationPage extends StatefulWidget {
  final dynamic conversation;
  final String token;
  final String name;

  ConversationPage(this.conversation, this.token, this.name);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  List<dynamic> messages = [];
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(
        Uri.https('caen0001.mds-caen.yt', '/conversations/${widget.conversation['id']}/messages'),
        headers: {'Authorization': '${widget.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          messages = jsonDecode(response.body);
        });
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
        // Gérer les erreurs de récupération des messages
      }
    } catch (e) {
      print('Erreur de connexion : $e');
      // Gérer les erreurs de connexion
    }
  }

  Future<void> sendMessage() async {
    final messageContent = _messageController.text;
    final senderName = widget.name;

    try {
      final response = await http.post(
        Uri.https('caen0001.mds-caen.yt', '/conversations/${widget.conversation['id']}/messages'),
        headers: {'Authorization': '${widget.token}', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': messageContent,
          'sender_name': senderName,
        }),
      );

      if (response.statusCode == 201) {
        // Message envoyé avec succès
        _messageController.clear();
        fetchMessages(); // Rafraîchir la liste des messages
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
        // Gérer les erreurs d'envoi du message
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
        title: Text('Conversation ${widget.conversation['id']}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];
                final senderName = message['is_sent_by_human'] ? 'Moi' : widget.name;
                final messageContent = message['content'];

                return ListTile(
                  title: Text(senderName),
                  subtitle: Text(messageContent),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Votre message',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: Text('Envoyer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
