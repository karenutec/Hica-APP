import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/tratamiento.dart';
import '../providers/auth_provider.dart';
import '../config/env.dart';

class TratamientoService {
  final String baseUrl = Environment.baseUrl;
  final AuthProvider authProvider;

  TratamientoService(this.authProvider);

  Future<HttpClient> _createClient() async {
    HttpClient client = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    return client;
  }

  Future<List<Tratamiento>> getTratamientosByVeterinarioId(int veterinarioId) async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    // Logs detallados de la solicitud
    print('\n=== DETALLES DE LA SOLICITUD ===');
    print('URL completa: $veterinarioId');
    print('Método: GET');
    print('Headers: {');
    print('  Authorization: Bearer $token');
    print('  Content-Type: application/json');
    print('}');
    print('================================\n');

    final client = await _createClient();
    
    try {
      final request = await client.getUrl(
        Uri.parse('$baseUrl/tratamientos/veterinario/$veterinarioId')
      );
      
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');
      request.headers.set('Authorization', 'Bearer $token');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(responseBody);
        return jsonData.map((json) => Tratamiento.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tratamientos: ${response.statusCode}');
      }
    } finally {
      client.close();
    }
  }

  Future<bool> actualizarEstadoTratamiento(String id, String nuevoEstado) async {
    final estadosValidos = ['PENDIENTE', 'APROBADO', 'RECHAZADO'];
    final token = authProvider.token;

    print('##############   ESTADO ENVIADO  ##################');
    print(nuevoEstado);

    if (!estadosValidos.contains(nuevoEstado)) {
      throw ArgumentError('Estado no válido');
    }

    print('##############   SOLICITUD ENVIADA  ##################');
    print('$baseUrl/tratamientos/$id/$nuevoEstado');

    final client = await _createClient();
    
    try {
      final request = await client.putUrl(
        Uri.parse('$baseUrl/tratamientos/$id/$nuevoEstado')
      );
      
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Authorization', 'Bearer $token');

      final response = await request.close();
      await response.transform(utf8.decoder).join(); // Consumir la respuesta

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update tratamiento state');
      }
    } finally {
      client.close();
    }
  }
}