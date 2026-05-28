import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class SmartPantryApp extends StatelessWidget {
  const SmartPantryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPantry',
      theme: AppTheme.light(),
      onGenerateRoute: AppRouter.routes(),
      initialRoute: '/',
    );
  }
}
