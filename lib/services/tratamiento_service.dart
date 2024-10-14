import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/tratamiento.dart';
import '../providers/auth_provider.dart';

class TratamientoService {
  final String baseUrl = 'http://192.168.1.9:4500';
  final AuthProvider authProvider;

  TratamientoService(this.authProvider);

  Future<List<Tratamiento>> getTratamientosByVeterinarioId(int veterinarioId) async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v10/tratamientos/veterinario/$veterinarioId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Tratamiento.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tratamientos: ${response.statusCode}');
      }
    } 
}