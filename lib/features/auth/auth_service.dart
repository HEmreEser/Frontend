import 'dart:convert';
import 'package:http/http.dart' as http;

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
      return data['token'] as String;
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
      // Backend gibt User-Objekt zurück, nicht Token! => Token musst du ggf. durch Login holen oder ID extrahieren
      // Für Dummy-Zwecke einfach direkt einloggen:
      return await login(email, password);
    } else {
      throw Exception(
        jsonDecode(res.body) is Map
            ? jsonDecode(res.body)['message'] ?? 'Registrierung fehlgeschlagen'
            : res.body,
      );
    }
  }
}
