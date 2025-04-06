// providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  // Secure storage instance for storing the auth token
  final _storage = FlutterSecureStorage();

  // Internal login state
  bool _isLoggedIn = false;

  // Public getter for login state
  bool get isLoggedIn => _isLoggedIn;

  // Constructor: check login status on provider initialization
  AuthProvider() {
    checkLoginStatus();
  }

  // Check if token exists in secure storage to determine login state
  Future<void> checkLoginStatus() async {
    final token = await _storage.read(key: 'token');
    _isLoggedIn = token != null;
    notifyListeners();
  }

  // Save token to secure storage and update login state
  Future<void> login(String token) async {
    await _storage.write(key: 'token', value: token);
    _isLoggedIn = true;
    notifyListeners();
  }

  // Remove token from secure storage and update login state
  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _isLoggedIn = false;
    notifyListeners();
  }
}
