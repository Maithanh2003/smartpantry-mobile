import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/splash_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../di/app_services.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) async {
        final loggedIn = await AppServices.authRepository.isLoggedIn();
        final path = state.matchedLocation;
        final isAuthRoute = path == '/login' || path == '/register';
        final isSplash = path == '/';

        if (isSplash) {
          return null;
        }
        if (!loggedIn && !isAuthRoute) {
          return '/login';
        }
        if (loggedIn && isAuthRoute) {
          return '/home';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text(state.error.toString())),
      ),
    );
  }
}
