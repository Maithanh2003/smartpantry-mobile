import '../../../core/network/api_exception.dart';
import '../../../core/storage/token_storage.dart';
import '../domain/models/auth_session.dart';
import '../domain/models/auth_user.dart';
import 'auth_api.dart';

class AuthRepository {
  AuthRepository(this._api, this._tokenStorage);

  final AuthApi _api;
  final TokenStorage _tokenStorage;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final session = await _api.login(email: email, password: password);
    await _persist(session);
    return session;
  }

  Future<AuthSession> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final session = await _api.register(
      email: email,
      password: password,
      fullName: fullName,
    );
    await _persist(session);
    return session;
  }

  Future<bool> refreshSession() async {
    final refresh = await _tokenStorage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      return false;
    }
    try {
      final tokens = await _api.refresh(refreshToken: refresh);
      await _tokenStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      return true;
    } on ApiException {
      await logout();
      return false;
    }
  }

  Future<AuthUser?> currentUser() async {
    if (!await _tokenStorage.hasAccessToken()) {
      return null;
    }
    try {
      return await _api.me();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        final refreshed = await refreshSession();
        if (refreshed) {
          return _api.me();
        }
      }
      rethrow;
    }
  }

  Future<void> logout() => _tokenStorage.clear();

  Future<bool> isLoggedIn() => _tokenStorage.hasAccessToken();

  Future<void> _persist(AuthSession session) {
    return _tokenStorage.saveTokens(
      accessToken: session.tokens.accessToken,
      refreshToken: session.tokens.refreshToken,
    );
  }
}
