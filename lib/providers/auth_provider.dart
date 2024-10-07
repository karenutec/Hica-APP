import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/veterinario.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  Veterinario? _veterinario;
  bool _isAuthenticated = false;
  String? _token;
  final AuthService _authService = AuthService();

  User? get user => _user;
  Veterinario? get veterinario => _veterinario;
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _user?.id;
  String? get token => _token;

  Future<bool> signIn(String email, String password) async {
    try {
      final response = await _authService.signIn(email, password);
      
      print('Respuesta completa en AuthProvider: $response'); // Para depuración

      if (response != null && response is Map<String, dynamic>) {
        if (response['message'] == "Usuario logueado correctamente" && response.containsKey('data')) {
          final data = response['data'] as Map<String, dynamic>;
          
          if (data.containsKey('token') && data.containsKey('user')) {
            _token = data['token'] as String;
            final userData = data['user'] as Map<String, dynamic>;
            _user = User(id: userData['id'], email: userData['email']);
            _isAuthenticated = true;
            notifyListeners();
            return true;
          } else {
            print('La respuesta no contiene token o user en data');
          }
        } else {
          print('Mensaje de respuesta inesperado o falta la clave data');
        }
      } else {
        print('La respuesta es nula o no es un Map');
      }
      
      return false;
    } catch (e) {
      print('Error en signIn: $e');
      return false;
    }
  }

  void setVeterinarioDetails(Veterinario veterinario) {
    _veterinario = veterinario;
    notifyListeners();
  }

  void signOut() {
    _user = null;
    _veterinario = null;
    _isAuthenticated = false;
    _token = null;
    notifyListeners();
  }
}