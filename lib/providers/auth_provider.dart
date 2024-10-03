import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/azure_face_service.dart';
import 'dart:io';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  final AuthService _authService = AuthService();
  final AzureFaceService _azureFaceService = AzureFaceService();

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> signIn(String email, String password) async {
    try {
      _user = await _authService.signIn(email, password);
      notifyListeners();
      return _user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> verifyFace(File imageFile) async {
    if (_user == null || _user!.faceId == null) {
      return false;
    }
    try {
      bool isVerified = await _azureFaceService.verifyFace(imageFile, _user!.faceId!);
      if (isVerified) {
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