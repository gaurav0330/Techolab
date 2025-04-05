import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final url = Uri.parse(ApiConstants.login);
    final response = await http.post(
      url,
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      await storage.write(key: 'token', value: token);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    final url = Uri.parse(ApiConstants.register);
    final response = await http.post(
      url,
      body: {'email': email, 'password': password},
    );

    return response.statusCode == 200;
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }
}
