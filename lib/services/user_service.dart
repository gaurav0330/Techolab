import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/user_model.dart';

class UserService {
  // Fetches users from the API with optional pagination
  Future<List<User>> fetchUsers({int page = 1}) async {
    final url = Uri.parse('${ApiConstants.users}?page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Creates a new user and returns the User object
  Future<User> createUser(String name, String job) async {
    final response = await http.post(
      Uri.parse(ApiConstants.users),
      body: {'name': name, 'job': job},
    );

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);

      // Parse name into first and last name (fallback logic)
      final nameParts = name.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : name;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      return User(
        id: int.tryParse(jsonData['id'].toString()) ?? 0,
        email: '${firstName.toLowerCase()}@example.com',
        firstName: firstName,
        lastName: lastName,
        avatar: 'https://ui-avatars.com/api/?name=$firstName+$lastName',
        jobTitle: job,
        createdAt: DateTime.now(),
      );
    } else {
      throw Exception('Failed to create user');
    }
  }

  // Updates user data (name and job)
  Future<User> updateUser(int id, String name, String job) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.users}/$id'),
      body: {'name': name, 'job': job},
    );

    if (response.statusCode == 200) {
      return User(
        id: id,
        email: '',
        firstName: name,
        lastName: '',
        avatar: 'https://via.placeholder.com/150',
      );
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Deletes user by ID
  Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.users}/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
