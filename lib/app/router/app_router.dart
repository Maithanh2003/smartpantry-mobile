import 'package:flutter/material.dart';

import '../../features/health/presentation/health_home_page.dart';

class AppRouter {
  static RouteFactory routes() {
    return (settings) {
      switch (settings.name) {
        case '/':
          return MaterialPageRoute<void>(
            builder: (_) => const HealthHomePage(),
            settings: settings,
          );
        default:
          return MaterialPageRoute<void>(
            builder: (_) => const HealthHomePage(),
            settings: settings,
          );
      }
    };
  }
}
