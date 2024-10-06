import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  final String _loginUrl = 'http://172.168.30.20:4500/api/v10/login';

  Future<User?> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final String token = responseData['data']['token'];
        final Map<String, dynamic> userData = responseData['data']['user'];

        // Crea el usuario con la información proporcionada por la API
        final user = User(
          id: userData['id'],
          email: userData['email'],
          token: token,
        );
        return user;
      } else {
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
