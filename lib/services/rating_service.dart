import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rating_response.dart';

class RatingService {
  final String baseUrl = "http://localhost:8080/api/ratings";

  Future<List<RatingResponse>> fetchRatingsForEquipment(int equipmentId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/equipment/$equipmentId"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => RatingResponse.fromJson(e)).toList();
    }
    throw Exception("Fehler beim Laden der Bewertungen");
  }

  Future<void> submitRating({
    required int equipmentId,
    required int stars,
    String? comment,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "equipmentId": equipmentId,
        "stars": stars,
        "comment": comment,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Fehler beim Bewerten: ${response.body}");
    }
  }
}
