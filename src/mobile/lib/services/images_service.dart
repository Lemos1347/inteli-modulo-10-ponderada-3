import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageService {
  final String baseUrl = 'http://192.168.103.104:3000';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> uploadImage(File image) async {
    try {
      final token = await _getToken();
      final uri = Uri.parse('$baseUrl/images');
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data'
        })
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      var response = await request.send();
      if (response.statusCode != 200) {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<List<String>> fetchImages() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/images'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> imagesJson = json.decode(response.body);
        return imagesJson.cast<String>();
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Failed to load images: $e');
    }
  }

  Future<File> fetchImage(String filename) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/image?folder=processed&filename=$filename'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final directory = await Directory.systemTemp.createTemp();
        final filePath = join(directory.path, filename);
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }
}
