import 'package:dio/dio.dart';

import '../../storage/token_storage.dart';

typedef RefreshTokensCallback = Future<bool> Function();

/// Attaches Bearer token; on 401 attempts one refresh + retry (except auth endpoints).
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    required RefreshTokensCallback onRefresh,
  })  : _dio = dio,
        _tokenStorage = tokenStorage,
        _onRefresh = onRefresh;

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final RefreshTokensCallback _onRefresh;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isPublic(options.path)) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    if (response?.statusCode != 401 || _isPublic(err.requestOptions.path)) {
      handler.next(err);
      return;
    }

    final refreshed = await _onRefresh();
    if (!refreshed) {
      handler.next(err);
      return;
    }

    try {
      final token = await _tokenStorage.getAccessToken();
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $token';
      final retryResponse = await _dio.fetch<dynamic>(opts);
      handler.resolve(retryResponse);
    } catch (e) {
      handler.next(err);
    }
  }

  bool _isPublic(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh') ||
        path.endsWith('/health');
  }
}
