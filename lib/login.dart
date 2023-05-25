import 'package:flutter/material.dart';
import 'dart:convert';
import './welcome.dart';
import 'package:http/http.dart' as http;
import 'createAccountPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _token;

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final String body = json.encode({
      'username': username,
      'password': password,
    });

    final response = await http.post(
      Uri.https('caen0001.mds-caen.yt', '/auth'),
      body: body,
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final token = data['token'];
      final idUser = data['id'];

      setState(() {
        _token = token;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Félicitations !'),
          content: const Text('Identifiants corrects. Vous êtes connecté'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return WelcomePage(_token!, idUser!);
                    },
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
          title: const Text('Erreur de connexion'),
          content: const Text('Identifiants invalides. Veuillez réessayer.'),
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

  void _navigateToCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CreateAccountPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page de Connexion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nom d\'utilisateur',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de Passe',
              ),
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Se connecter'),
            ),
            TextButton(
              onPressed: _navigateToCreateAccount,
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}

