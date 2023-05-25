import 'package:flutter/material.dart';

class ShowConversationPage extends StatelessWidget {
  final dynamic character;

  ShowConversationPage(this.character);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation avec ${character['name']}'),
      ),
      body: Center(
        child: Text(
          'Contenu de la conversation avec ${character['name']}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
