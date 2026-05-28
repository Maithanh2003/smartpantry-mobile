import '../../core/network/api_client.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/token_storage.dart';
import '../../features/auth/data/auth_api.dart';
import '../../features/auth/data/auth_repository.dart';

/// Simple app-wide service holder (Phase A — no full DI framework yet).
class AppServices {
  AppServices._();

  static late final TokenStorage tokenStorage;
  static late final ApiClient apiClient;
  static late final AuthRepository authRepository;

  static AuthRepository? _authRepositoryRef;

  static Future<void> init() async {
    tokenStorage = TokenStorage();

    DioClient.configure(
      tokenStorage: tokenStorage,
      onRefresh: () async {
        final repo = _authRepositoryRef;
        if (repo == null) {
          return false;
        }
        return repo.refreshSession();
      },
    );

    apiClient = ApiClient();
    authRepository = AuthRepository(AuthApi(apiClient), tokenStorage);
    _authRepositoryRef = authRepository;
  }
}
