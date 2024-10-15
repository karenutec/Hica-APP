import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/tratamiento.dart';
import '../providers/auth_provider.dart';

class TratamientoService {
  final String baseUrl = 'http://hicaapimovil.azure-api.net/movil';
  final AuthProvider authProvider;

  TratamientoService(this.authProvider);

  Future<List<Tratamiento>> getTratamientosByVeterinarioId(int veterinarioId) async {
    final token = authProvider.token;
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/tratamientos/veterinario/$veterinarioId'),
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

  Future<bool> actualizarEstadoTratamiento(String id, String nuevoEstado) async {
    final estadosValidos = ['PENDIENTE', 'APROBADO', 'RECHAZADO'];

    print('##############   ESTADO ENVIADO  ##################');
    print(nuevoEstado);

    if (!estadosValidos.contains(nuevoEstado)) {
      throw ArgumentError('Estado no válido');
    }

    print('##############   SOLICITUD ENVIADA  ##################');
    print('$baseUrl/tratamientos/$id/$nuevoEstado');

    final response = await http.put(
      Uri.parse('$baseUrl/tratamientos/$id/$nuevoEstado'),
      headers: {
        'Authorization': 'Bearer ${authProvider.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update tratamiento state');
    }
  }

}