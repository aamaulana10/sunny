import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny/feature/mainTabbar/mainTabbar.dart';

import 'core/config/notification/notificationManager.dart';

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
      home: MainTabbar()
    );
  }
}