class UserResponse {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
