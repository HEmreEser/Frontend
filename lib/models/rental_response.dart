class RentalResponse {
  final int id;
  final int equipmentId;
  final String equipmentName;
  final DateTime startDate;
  final DateTime endDate;
  final bool returned;
  final bool extended;

  RentalResponse({
    required this.id,
    required this.equipmentId,
    required this.equipmentName,
    required this.startDate,
    required this.endDate,
    required this.returned,
    required this.extended,
  });

  factory RentalResponse.fromJson(Map<String, dynamic> json) => RentalResponse(
    id: json['id'],
    equipmentId: json['equipmentId'],
    equipmentName: json['equipmentName'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    returned: json['returned'],
    extended: json['extended'],
  );
}
