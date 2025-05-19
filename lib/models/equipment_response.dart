class EquipmentResponse {
  final int id;
  final String name;
  final String type;
  final String description;
  final bool available;
  final int categoryId;
  final String categoryName;
  final int locationId;
  final String locationName;

  EquipmentResponse({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.available,
    required this.categoryId,
    required this.categoryName,
    required this.locationId,
    required this.locationName,
  });

  factory EquipmentResponse.fromJson(Map<String, dynamic> json) =>
      EquipmentResponse(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        description: json['description'],
        available: json['available'],
        categoryId: json['categoryId'],
        categoryName: json['categoryName'],
        locationId: json['locationId'],
        locationName: json['locationName'],
      );
}
