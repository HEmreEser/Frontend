import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rental_response.dart';

class RentalService {
  final String baseUrl = "http://localhost:8080/api/rentals";

  Future<List<RentalResponse>> fetchMyRentals() async {
    final response = await http.get(Uri.parse("$baseUrl/user"));
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => RentalResponse.fromJson(e)).toList();
    }
    throw Exception("Fehler beim Laden deiner Ausleihen");
  }

  Future<void> rentEquipment({
    required int equipmentId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "equipmentId": equipmentId,
        "startDate": startDate.toIso8601String().split('T').first,
        "endDate": endDate.toIso8601String().split('T').first,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Fehler beim Ausleihen: ${response.body}");
    }
  }

  Future<void> returnRental(int rentalId) async {
    final response = await http.post(Uri.parse("$baseUrl/$rentalId/return"));
    if (response.statusCode != 200) {
      throw Exception("Fehler beim Zurückgeben: ${response.body}");
    }
  }
}
