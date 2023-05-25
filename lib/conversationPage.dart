import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services/apiservice.dart';

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
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService('caen0001.mds-caen.yt', widget.token);
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final response = await apiService.get('/conversations/${widget.conversation['id']}/messages');

    if (response != null && response is List<dynamic>) {
      setState(() {
        messages = response;
      });
    } else {
      // Gérer les erreurs de récupération des messages
    }
  }

  Future<void> sendMessage() async {
    final messageContent = _messageController.text;
    final senderName = widget.name;

    final response = await apiService.post('/conversations/${widget.conversation['id']}/messages', {
      'content': messageContent,
      'sender_name': senderName,
    });

    if (response != null) {
      _messageController.clear();
      fetchMessages();
    } else {
      // Gérer les erreurs d'envoi du message
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
