import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  final String baseUrl = 'http://282.987.987.987:3000';

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
}
