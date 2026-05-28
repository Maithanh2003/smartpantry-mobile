import 'package:dio/dio.dart';

import '../config/env.dart';
import 'api_error_mapper.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'dio_client.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  Future<ApiResponse<T>> request<T>(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    dynamic data,
    T Function(dynamic raw)? dataMapper,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        _withApiPrefix(path),
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw ApiException(
          code: 'INVALID_RESPONSE',
          message: 'Response is not a JSON object',
          statusCode: response.statusCode,
        );
      }
      final parsed = ApiResponse<T>.fromJson(body, dataMapper: dataMapper);
      if (!parsed.success) {
        final err = parsed.error;
        throw ApiException(
          code: err?.code ?? 'API_ERROR',
          message: err?.message ?? (parsed.message ?? 'Request failed'),
          statusCode: response.statusCode,
          fields: err?.fields,
        );
      }
      return parsed;
    } on DioException catch (e) {
      throw ApiErrorMapper.mapDio(e);
    }
  }

  Future<Map<String, dynamic>> health() async {
    final response = await request<Map<String, dynamic>>(
      '/health',
      dataMapper: (raw) => Map<String, dynamic>.from(raw as Map),
    );
    return response.requireData();
  }

  String _withApiPrefix(String path) {
    if (path == '/health') {
      return path;
    }
    if (path.startsWith(Env.apiPrefix)) {
      return path;
    }
    if (path.startsWith('/')) {
      return '${Env.apiPrefix}$path';
    }
    return '${Env.apiPrefix}/$path';
  }
}
