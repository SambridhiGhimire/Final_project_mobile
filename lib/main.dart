import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:wastemanagement/app/app.dart';
import 'package:wastemanagement/app/di/di.dart';

import 'core/network/hive_service.dart';

// Initialize once in the very beginning
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive Database
  await HiveService().init();
  // Initialize dependencies
  await initDependencies();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(App());
}
