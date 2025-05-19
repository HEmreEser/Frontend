import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_response.dart';

class UserService {
  final String baseUrl = "http://localhost:8080/api/users/me";

  Future<UserResponse> fetchMyProfile() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return UserResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception("Fehler beim Laden deines Profils");
  }
}
