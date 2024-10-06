import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  final AuthService _authService = AuthService();

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> signIn(String email, String password) async {
    try {
      _user = await _authService.signIn(email, password);
      if (_user != null) {
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void signOut() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
