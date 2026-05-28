class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.fullName,
    this.status,
  });

  final String id;
  final String email;
  final String? fullName;
  final String? status;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString(),
      status: json['status']?.toString(),
    );
  }
}
