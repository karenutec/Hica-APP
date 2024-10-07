import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/veterinario.dart';
import '../providers/auth_provider.dart';

class VeterinarioService {
  final String baseUrl = 'http://192.168.1.12:4500';
  final AuthProvider authProvider;

  VeterinarioService(this.authProvider);

  Future<Veterinario> getVeterinarioDetails(String userId) async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v10/veterinarios/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Veterinario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar veterinario: ${response.statusCode}');
    }
  }
}