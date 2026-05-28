import 'auth_tokens.dart';
import 'auth_user.dart';

class AuthSession {
  const AuthSession({
    required this.user,
    required this.tokens,
  });

  final AuthUser user;
  final AuthTokens tokens;

  factory AuthSession.fromLoginJson(Map<String, dynamic> json) {
    return AuthSession(
      user: AuthUser.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
      tokens: AuthTokens.fromJson(Map<String, dynamic>.from(json['tokens'] as Map)),
    );
  }
}
