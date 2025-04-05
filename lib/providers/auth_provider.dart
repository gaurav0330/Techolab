// providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = FlutterSecureStorage();
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await _storage.read(key: 'token');
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<void> login(String token) async {
    await _storage.write(key: 'token', value: token);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _isLoggedIn = false;
    notifyListeners();
  }
}
