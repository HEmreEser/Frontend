import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/equipment_response.dart';

class EquipmentService {
  final String baseUrl = "http://localhost:8080/api/equipment";

  /// Holt die Details zu einem einzelnen Gerät direkt über den passenden Endpunkt!
  Future<EquipmentResponse> fetchEquipmentDetail(int id) async {
    // Annahme: Es existiert (besser!) ein dedizierter Endpunkt `/api/equipment/{id}`
    final response = await http.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> item = jsonDecode(response.body);
      return EquipmentResponse.fromJson(item);
    } else if (response.statusCode == 404) {
      throw Exception("Gerät nicht gefunden");
    }
    throw Exception("Fehler beim Laden der Gerätedetails");
  }

  /// Holt alle verfügbaren Geräte
  Future<List<EquipmentResponse>> fetchAllAvailable() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => EquipmentResponse.fromJson(e)).toList();
    }
    throw Exception("Fehler beim Laden der Geräte");
  }

  /// Holt alle Geräte (egal ob verfügbar)
  Future<List<EquipmentResponse>> fetchAll() async {
    final response = await http.get(Uri.parse("$baseUrl/all"));
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => EquipmentResponse.fromJson(e)).toList();
    }
    throw Exception("Fehler beim Laden aller Geräte");
  }
}
