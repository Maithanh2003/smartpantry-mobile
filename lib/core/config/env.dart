/// Runtime config from `--dart-define-from-file` (see `env/*.json`, `env/README.md`).
///
/// Never hardcode API URLs in Dart — use Docker Compose `DART_DEFINE_ENV_FILE` or
/// `flutter run --dart-define-from-file=env/local.json`.
class Env {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static const String apiPrefix = String.fromEnvironment(
    'API_PREFIX',
    defaultValue: '/api/v1',
  );
}
