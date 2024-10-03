import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class AzureFaceService {
  final String apiKey = 'TU_API_KEY_AQUI';
  final String endpoint = 'https://TU_ENDPOINT_AQUI.cognitiveservices.azure.com/';

  Future<bool> verifyFace(File imageFile, String faceId) async {
    var detectedFaceId = await detectFace(imageFile);
    if (detectedFaceId == null) {
      return false;
    }

    var verifyUrl = '${endpoint}face/v1.0/verify';
    var response = await http.post(
      Uri.parse(verifyUrl),
      headers: {
        'Content-Type': 'application/json',
        'Ocp-Apim-Subscription-Key': apiKey,
      },
      body: json.encode({
        'faceId1': detectedFaceId,
        'faceId2': faceId,
      }),
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return result['isIdentical'] && result['confidence'] > 0.5;
    } else {
      throw Exception('Failed to verify face');
    }
  }

  Future<String?> detectFace(File imageFile) async {
    var detectUrl = '${endpoint}face/v1.0/detect';
    var request = http.MultipartRequest('POST', Uri.parse(detectUrl));
    request.headers['Ocp-Apim-Subscription-Key'] = apiKey;
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var faces = json.decode(responseBody);
      if (faces.isNotEmpty) {
        return faces[0]['faceId'];
      }
    }
    return null;
  }
}