import '../../../core/network/api_client.dart';
import '../domain/models/auth_session.dart';
import '../domain/models/auth_tokens.dart';
import '../domain/models/auth_user.dart';

class AuthApi {
  AuthApi(this._client);

  final ApiClient _client;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.request<Map<String, dynamic>>(
      '/auth/login',
      method: 'POST',
      data: {'email': email.trim(), 'password': password},
      dataMapper: (raw) => Map<String, dynamic>.from(raw as Map),
    );
    return AuthSession.fromLoginJson(response.requireData());
  }

  Future<AuthSession> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _client.request<Map<String, dynamic>>(
      '/auth/register',
      method: 'POST',
      data: {
        'email': email.trim(),
        'password': password,
        'full_name': fullName.trim(),
      },
      dataMapper: (raw) => Map<String, dynamic>.from(raw as Map),
    );
    return AuthSession.fromLoginJson(response.requireData());
  }

  Future<AuthTokens> refresh({required String refreshToken}) async {
    final response = await _client.request<Map<String, dynamic>>(
      '/auth/refresh',
      method: 'POST',
      data: {'refresh_token': refreshToken},
      dataMapper: (raw) => Map<String, dynamic>.from(raw as Map),
    );
    return AuthTokens.fromJson(response.requireData());
  }

  Future<AuthUser> me() async {
    final response = await _client.request<Map<String, dynamic>>(
      '/auth/me',
      dataMapper: (raw) => Map<String, dynamic>.from(raw as Map),
    );
    return AuthUser.fromJson(response.requireData());
  }
}
