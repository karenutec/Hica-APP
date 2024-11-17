import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../config/env.dart';

class CloudinaryService {
  
  final String cloudName = Environment.cloud_name;
  final String apiKey = Environment.api_key;
  final String apiSecret = Environment.api_secret;

  // Método para subir imagen
  Future<Map<String, String>> uploadImage(File imageFile) async {
    try {
      // Convertir imagen a base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64String = base64Encode(imageBytes);

      final Uri url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload'
      );

      
      final response = await http.post(
        url,
        body: jsonEncode({
          'file': 'data:image/jpeg;base64,$base64String',
          'api_key': apiKey,
          'folder': 'movil',
          'resource_type': 'image'
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'url': responseData['secure_url'],
          'public_id': responseData['public_id'],
        };
      } else {
        throw Exception('Error al subir imagen: ${response.body}');
      }
    } catch (e) {
      print('Error en uploadImage: $e');
      throw Exception('Error al subir la imagen: $e');
    }
  }

  // Método para eliminar imagen
  Future<void> deleteImage(String publicId) async {
    try {
      final Uri url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/destroy'
      );

      final response = await http.post(
        url,
        body: {
          'public_id': publicId,
          'api_key': apiKey,
        }
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar la imagen');
      }
    } catch (e) {
      print('Error en deleteImage: $e');
      throw Exception('Error al eliminar la imagen: $e');
    }
  }
}

// Ejemplo de uso
void ejemploDeUso() async {
  final cloudinaryService = CloudinaryService();
  
  try {
    // Para subir una imagen
    File imagen = File('ruta/de/tu/imagen.jpg');
    final resultado = await cloudinaryService.uploadImage(imagen);
    print('URL de la imagen: ${resultado['url']}');
    print('Public ID: ${resultado['public_id']}');
    
  } catch (e) {
    print('Error: $e');
  }
}