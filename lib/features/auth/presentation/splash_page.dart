import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/app_services.dart';
import '../../../app/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final loggedIn = await AppServices.authRepository.isLoggedIn();
    if (!mounted) {
      return;
    }
    context.go(loggedIn ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text('SmartPantry', style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
