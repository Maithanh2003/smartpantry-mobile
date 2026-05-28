import 'env.dart';

/// Backward-compatible alias while migrating to Env-based config.
class AppConfig {
  static const String baseUrl = Env.apiBaseUrl;
}
