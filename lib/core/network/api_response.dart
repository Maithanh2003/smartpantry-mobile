import 'api_exception.dart';

class ApiMeta {
  final String? requestId;
  final String? timestamp;
  final Map<String, dynamic> extra;

  ApiMeta({
    required this.requestId,
    required this.timestamp,
    required this.extra,
  });

  factory ApiMeta.fromJson(Map<String, dynamic>? json) {
    final source = json ?? <String, dynamic>{};
    final extra = Map<String, dynamic>.from(source)
      ..remove('request_id')
      ..remove('timestamp');
    return ApiMeta(
      requestId: source['request_id']?.toString(),
      timestamp: source['timestamp']?.toString(),
      extra: extra,
    );
  }
}

class ApiError {
  final String code;
  final String message;
  final Map<String, String>? fields;

  ApiError({required this.code, required this.message, this.fields});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    Map<String, String>? fields;
    if (rawFields is Map) {
      fields = rawFields.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return ApiError(
      code: json['code']?.toString() ?? 'UNKNOWN_ERROR',
      message: json['message']?.toString() ?? 'Unknown error',
      fields: fields,
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final ApiError? error;
  final ApiMeta meta;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.error,
    required this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic raw)? dataMapper,
  }) {
    final success = json['success'] == true;
    final data = dataMapper != null
        ? dataMapper(json['data'])
        : json['data'] as T?;
    final errorJson = json['error'];

    return ApiResponse<T>(
      success: success,
      message: json['message']?.toString(),
      data: data,
      error: errorJson is Map<String, dynamic>
          ? ApiError.fromJson(errorJson)
          : null,
      meta: ApiMeta.fromJson(json['meta'] as Map<String, dynamic>?),
    );
  }

  T requireData() {
    if (success && data != null) {
      return data as T;
    }
    if (error != null) {
      throw ApiException(
        code: error!.code,
        message: error!.message,
        fields: error!.fields,
      );
    }
    throw ApiException(
      code: 'INVALID_RESPONSE',
      message: message ?? 'Response does not contain data',
    );
  }
}
