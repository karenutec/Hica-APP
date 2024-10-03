import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = 'https://tu-api.com'; // Reemplaza con la URL de tu API

  Future<User?> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to sign in');
    }
  }
}