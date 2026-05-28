import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'api_response.dart';

class ApiErrorMapper {
  static ApiException mapDio(DioException e) {
    final body = e.response?.data;
    if (body is Map<String, dynamic>) {
      final parsed = ApiResponse<Map<String, dynamic>>.fromJson(body);
      final err = parsed.error;
      return ApiException(
        code: err?.code ?? 'HTTP_ERROR',
        message:
            err?.message ?? (parsed.message ?? e.message ?? 'Request failed'),
        statusCode: e.response?.statusCode,
        fields: err?.fields,
      );
    }
    return ApiException(
      code: 'NETWORK_ERROR',
      message: e.message ?? 'Network request failed',
      statusCode: e.response?.statusCode,
    );
  }
}
