import 'package:flutter/material.dart';
import 'package:sunny/core/app.dart';

import 'core/service/notification/notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationManager.instance.init();
  await NotificationManager.instance.requestPermissions();

  runApp(MyApp());
}
