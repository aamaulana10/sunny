import 'package:flutter/material.dart';
import 'package:sunny/feature/mainTabbar/main_tabbar.dart';

import 'core/config/notification/notification_manager.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  NotificationManager notificationManager = NotificationManager();

  notificationManager.init();
  notificationManager.requestPermissions();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainTabbar(selectedIndex: 0)
    );
  }
}