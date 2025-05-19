class UserResponse {
  final int id;
  final String name;
  final String email;
  final String role;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
