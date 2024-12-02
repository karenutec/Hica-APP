import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../config/env.dart';

class AuthService {
  final String baseUrl = Environment.baseUrl;

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    
    try {
      final request = await client.postUrl(Uri.parse('$baseUrl/login'));
      request.headers.set('content-type', 'application/json');
      
      final body = json.encode({'email': email, 'password': password});
      request.write(body);
      
      final response = await request.close();
      final stringData = await response.transform(utf8.decoder).join();
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = json.decode(stringData);
        print('Respuesta decodificada: $decodedResponse');
        return decodedResponse;
      } else {
        print('Error en la autenticación: ${response.statusCode}');
        print('Cuerpo de la respuesta: $stringData');
        return null;
      }
    } catch (e) {
      print('Excepción en AuthService.signIn: $e');
      return null;
    } finally {
      client.close();
    }
  }
}