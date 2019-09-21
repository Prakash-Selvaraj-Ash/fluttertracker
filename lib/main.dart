import 'package:bus_tracker_client/src/di/app_injector.dart';
import 'package:bus_tracker_client/src/di/app_module.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var container = await AppInjector.create(AppModule());
  App.sharedPref = await SharedPreferences.getInstance();
  runApp(container.app);
//  runApp(MapSam());
}

