import 'package:dio/dio.dart';

import '../config/env.dart';
import '../storage/token_storage.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio? _instance;

  static Dio get instance {
    final dio = _instance;
    if (dio == null) {
      throw StateError('DioClient not configured. Call DioClient.configure() first.');
    }
    return dio;
  }

  static void configure({
    required TokenStorage tokenStorage,
    required RefreshTokensCallback onRefresh,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        tokenStorage: tokenStorage,
        onRefresh: onRefresh,
      ),
    );
    _instance = dio;
  }
}
