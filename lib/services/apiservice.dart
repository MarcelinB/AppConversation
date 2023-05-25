import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;
  final String token;

  ApiService(this.baseUrl, this.token);

  Future<dynamic> get(String path) async {
    try {
      final response = await http.get(
        Uri.https(baseUrl, path),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur de connexion : $e');
      return null;
    }
  }

  Future<dynamic> post(String path, dynamic data) async {
    try {
      final response = await http.post(
        Uri.https(baseUrl, path),
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur de connexion : $e');
      return null;
    }
  }
}
