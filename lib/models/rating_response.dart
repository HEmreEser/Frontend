class RatingResponse {
  final int id;
  final int equipmentId;
  final int stars;
  final String? comment;
  final String userName;

  RatingResponse({
    required this.id,
    required this.equipmentId,
    required this.stars,
    required this.comment,
    required this.userName,
  });

  factory RatingResponse.fromJson(Map<String, dynamic> json) => RatingResponse(
    id: json['id'],
    equipmentId: json['equipmentId'],
    stars: json['stars'],
    comment: json['comment'],
    userName: json['userName'],
  );
}
