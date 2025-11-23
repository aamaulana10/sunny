import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  NotificationManager._();

  factory NotificationManager() => _instance;

  static final NotificationManager _instance = NotificationManager._();

  bool _initialized = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    print("NotificationManager call init function");

    if (!_initialized) {
      const androidSettings = AndroidInitializationSettings("ic_notif_icon");
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle notification tap
          print("Notification tapped with payload: ${response.payload}");
        },
      );

      await _configureLocalTimeZone();
      _initialized = true;
    }
  }

  Future<void> requestPermissions() async {
    // Android 13+ permission request
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      print("Notification permission granted: $grantedNotificationPermission");

      final bool? grantedExactAlarmPermission =
          await androidImplementation?.requestExactAlarmsPermission();
      print("Exact alarm permission granted: $grantedExactAlarmPermission");
    }

    // iOS permission request
    if (Platform.isIOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      print("iOS permission granted: $result");
    }
  }

  Future<void> showSimpleNotification({
    required String id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      "sunny_id",
      "sunny",
      channelDescription: "sunny notification",
      priority: Priority.high,
      importance: Importance.max,
      styleInformation: DefaultStyleInformation(true, true),
    );

    const iosDetails = DarwinNotificationDetails();

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: body,
    );
  }

  Future<void> showNotificationWithAttachment({
    required String id,
    required String title,
    required String body,
    required String imagePath,
    required String imageDescription,
  }) async {
    final attachmentPicturePath = await _downloadAndSaveFileImageNotification(
      imagePath,
      imageDescription,
    );

    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(attachmentPicturePath),
      contentTitle: '<b>$imageDescription</b>',
      htmlFormatContentTitle: true,
      summaryText: title,
      htmlFormatSummaryText: true,
    );

    final androidDetails = AndroidNotificationDetails(
      "sunny_id",
      "sunny",
      channelDescription: "sunny notification",
      priority: Priority.high,
      importance: Importance.max,
      styleInformation: bigPictureStyleInformation,
    );

    final platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: body,
    );
  }

  Future<void> showScheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required String imagePath,
    required String imageDescription,
  }) async {
    final attachmentPicturePath = await _downloadAndSaveFileImageNotification(
      imagePath,
      imageDescription,
    );

    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(attachmentPicturePath),
      contentTitle: '<b>$imageDescription</b>',
      htmlFormatContentTitle: true,
      summaryText: title,
      htmlFormatSummaryText: true,
    );

    final androidDetails = AndroidNotificationDetails(
      "sunny_id",
      "sunny",
      channelDescription: "sunny notification",
      priority: Priority.high,
      importance: Importance.max,
      styleInformation: bigPictureStyleInformation,
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    final scheduledTime = _nextInstanceOfHour(hour);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print(
      "Schedule set at ${scheduledTime.hour}:${scheduledTime.minute}.${scheduledTime.second}",
    );
  }

  Future<void> showScheduleSimpleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      "sunny_id",
      "sunny",
      channelDescription: "sunny notification",
      priority: Priority.high,
      importance: Importance.max,
      styleInformation: const DefaultStyleInformation(true, true),
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    final scheduledTime = _nextInstanceOfHour(hour);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print("Simple schedule set at ${scheduledTime.toLocal()}");
  }

  tz.TZDateTime _nextInstanceOfHour(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      0,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();

    // Gunakan timezone lokal dari device
    final String currentTimeZone = DateTime.now().timeZoneName;

    try {
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      print("Local timezone set to: $currentTimeZone");
    } catch (e) {
      // Fallback ke UTC jika timezone tidak ditemukan
      print("Error setting timezone: $e, using UTC as fallback");
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  Future<String> _downloadAndSaveFileImageNotification(
    String url,
    String fileName,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<File> _getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(
      byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );
    return file;
  }

  // Method tambahan untuk cancel notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // Method untuk cek pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Method untuk cek active notifications
  Future<List<ActiveNotification>> getActiveNotifications() async {
    final List<ActiveNotification>? activeNotifications =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.getActiveNotifications();
    return activeNotifications ?? [];
  }
}
