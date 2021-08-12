import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationManager {

  NotificationManager._();

  factory NotificationManager() => _instance;

  static final NotificationManager _instance = NotificationManager._();

  bool _initialized = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {

    print("NotificationManager call init function");

    if (!_initialized) {

      var androidSettings = AndroidInitializationSettings("playstore");

      var initSetttings = InitializationSettings(android: androidSettings);

      await flutterLocalNotificationsPlugin.initialize(
          initSetttings, onSelectNotification: onClickNotification);
    }

    _configureLocalTimeZone();

      _initialized = true;

    }

  void requestPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future onClickNotification(String payload) {
    print("payload " + payload);
  }

  showSimpleNotification({String id, String title, String body}) async {

    var androidDetails = AndroidNotificationDetails("sunny_id", "sunny ", "sunny notification",
        priority: Priority.high, importance: Importance.max,
        styleInformation: DefaultStyleInformation(true, true));
    var platformDetails = new NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, title,
        body, platformDetails,
        payload: body);
  }

  showNotificationWithAttachment({String id, String title, String body,
      String imagePath, String imageDescription}) async {

    var attachmentPicturePath = await _downloadAndSaveFileImageNotification(imagePath, imageDescription);

    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(attachmentPicturePath),
      contentTitle: '<b>$imageDescription</b>',
      htmlFormatContentTitle: true,
      summaryText: title,
      htmlFormatSummaryText: true,
    );

    var androidDetails = AndroidNotificationDetails("sunny_id", "sunny ", "sunny notification",
    priority: Priority.high, importance: Importance.max, styleInformation: bigPictureStyleInformation);
    var platformDetails = new NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, title,
        body, platformDetails,
        payload: body);
  }

  Future<void> showScheduleNotification({String id, String title, String body, int hour}) async {
    var time = Time(01, 55, 10);
    var androidChannelSpecifics = AndroidNotificationDetails(
      "sunny_id",
      "sunny ",
      "sunny notification",
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
    NotificationDetails(android: androidChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body, //null
      _nextInstanceOfTenAM(hour),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time
    );

    print("schedule set at ${_nextInstanceOfTenAM(hour).hour}:${_nextInstanceOfTenAM(hour).minute}.${_nextInstanceOfTenAM(hour).second}");
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.hour, hour, 00);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

    print("local timezone " + timeZoneName);
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _downloadAndSaveFileImageNotification(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

    _getImageFileFromAssets(String path) async {

    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$path');

    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;

  }
}