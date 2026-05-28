import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di/app_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppServices.init();
  runApp(SmartPantryApp());
}
