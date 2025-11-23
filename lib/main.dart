import 'package:flutter/material.dart';
import 'package:sunny/core/app.dart';

import 'core/service/notification/notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationManager notificationManager = NotificationManager();

  notificationManager.init();
  notificationManager.requestPermissions();

  runApp(MyApp());
}
