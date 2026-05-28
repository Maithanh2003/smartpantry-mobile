class ApiException implements Exception {
  final String code;
  final String message;
  final int? statusCode;
  final Map<String, String>? fields;

  ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.fields,
  });

  @override
  String toString() {
    return 'ApiException(code: $code, message: $message, statusCode: $statusCode, fields: $fields)';
  }
}
