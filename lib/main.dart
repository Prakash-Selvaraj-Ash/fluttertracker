import 'package:bus_tracker_client/src/di/app_injector.dart';
import 'package:bus_tracker_client/src/di/app_module.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var container = await AppInjector.create(AppModule());
  runApp(container.app);
}
