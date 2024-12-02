import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/veterinario.dart';
import '../providers/auth_provider.dart';
import '../config/env.dart';

class VeterinarioService {
  final String baseUrl = Environment.baseUrl;
  final AuthProvider authProvider;

  VeterinarioService(this.authProvider);

  Future<HttpClient> _createClient() async {
    HttpClient client = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    return client;
  }

  Future<Veterinario> getVeterinarioDetails(String userId) async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final client = await _createClient();
    
    try {
      final request = await client.getUrl(
        Uri.parse('$baseUrl/veterinarios/$userId')
      );
      
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');
      request.headers.set('Authorization', 'Bearer $token');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        return Veterinario.fromJson(json.decode(responseBody));
      } else {
        throw Exception('Error al cargar veterinario: ${response.statusCode}');
      }
    } finally {
      client.close();
    }
  }
}