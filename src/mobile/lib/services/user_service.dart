import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl = 'http://192.168.103.104:3000';

  Future<int> loginUser(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/users/login'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        await _saveToken(token);
      }
      return response.statusCode;
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  Future<int> registerUser(String name, String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/users'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return await loginUser(email, password);
      } else {
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
