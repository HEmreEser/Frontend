import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/equipment_response.dart';

class EquipmentService {
  final String baseUrl = "http://localhost:8080/api/equipment";

  Future<EquipmentResponse> fetchEquipmentDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/all"));
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      final item = list.firstWhere(
        (element) => element['id'] == id,
        orElse: () => null,
      );
      if (item == null) throw Exception("Gerät nicht gefunden");
      return EquipmentResponse.fromJson(item);
    }
    throw Exception("Fehler beim Laden der Gerätedetails");
  }

  Future<List<EquipmentResponse>> fetchAllAvailable() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => EquipmentResponse.fromJson(e)).toList();
    }
    throw Exception("Fehler beim Laden der Geräte");
  }
}
