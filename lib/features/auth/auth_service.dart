import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080/api/auth';

  Future<String> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final token = data['token'] as String;
      await _saveToken(token);
      return token;
    } else {
      throw Exception(
        jsonDecode(res.body) is Map
            ? jsonDecode(res.body)['message'] ?? 'Login fehlgeschlagen'
            : res.body,
      );
    }
  }

  Future<String> register(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final token = data['token'] as String;
      await _saveToken(token);
      return token;
    } else {
      throw Exception(
        jsonDecode(res.body) is Map
            ? jsonDecode(res.body)['message'] ?? 'Registrierung fehlgeschlagen'
            : res.body,
      );
    }
  }

  // --- NEU: Token-Handling mit SharedPreferences ---

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
