import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._();
  static NotificationManager get instance => _instance;

  NotificationManager._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // Initialize notification
  Future<void> init() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings("ic_notif_icon");
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _setupTimeZone();
    _initialized = true;
    debugPrint("✅ Notification initialized");
  }

  // Request permissions
  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      final android =
          _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await android?.requestNotificationsPermission();
    }

    if (Platform.isIOS) {
      final ios =
          _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();

      await ios?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  // Show instant notification
  Future<void> showNow({
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    final details = await _buildNotificationDetails(imageUrl: imageUrl);
    await _plugin.show(0, title, body, details);
  }

  // Schedule daily notification
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? imageUrl,
  }) async {
    final details = await _buildNotificationDetails(imageUrl: imageUrl);
    final scheduledTime = _getNextHourTime(hour, minute);

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.inexact,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint("\u26a0\ufe0f Exact alarm not permitted; using inexact schedule. Reason: $e");
    }

    debugPrint(
      "\ud83d\udcc5 Scheduled for ${scheduledTime.hour}:${scheduledTime.minute} daily",
    );
  }

  // Cancel specific notification
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPending() async {
    return await _plugin.pendingNotificationRequests();
  }

  // Private: Build notification details
  Future<NotificationDetails> _buildNotificationDetails({
    String? imageUrl,
  }) async {
    AndroidNotificationDetails android;

    if (imageUrl != null) {
      final imagePath = await _downloadImage(imageUrl);
      android = AndroidNotificationDetails(
        "sunny_id",
        "sunny",
        channelDescription: "sunny notification",
        priority: Priority.high,
        importance: Importance.max,
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(imagePath),
          htmlFormatContentTitle: true,
          htmlFormatSummaryText: true,
        ),
      );
    } else {
      android = const AndroidNotificationDetails(
        "sunny_id",
        "sunny",
        channelDescription: "sunny notification",
        priority: Priority.high,
        importance: Importance.max,
      );
    }

    return NotificationDetails(
      android: android,
      iOS: const DarwinNotificationDetails(),
    );
  }

  // Private: Download image for notification
  Future<String> _downloadImage(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = url.split('/').last;
    final filePath = '${dir.path}/$fileName';

    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }

  // Private: Get next scheduled time
  tz.TZDateTime _getNextHourTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  // Private: Setup timezone
  Future<void> _setupTimeZone() async {
    tz.initializeTimeZones();

    // Deteksi timezone berdasarkan offset UTC
    final currentOffset = DateTime.now().timeZoneOffset;

    // Map common timezone berdasarkan offset (dalam jam)
    final offsetHours = currentOffset.inHours;
    String timeZoneName;

    switch (offsetHours) {
      case 7:
        timeZoneName = 'Asia/Jakarta'; // WIB
        break;
      case 8:
        timeZoneName = 'Asia/Singapore'; // WITA
        break;
      case 9:
        timeZoneName = 'Asia/Tokyo'; // WIT
        break;
      case 0:
        timeZoneName = 'UTC';
        break;
      case 1:
        timeZoneName = 'Europe/London';
        break;
      case -5:
        timeZoneName = 'America/New_York';
        break;
      case -8:
        timeZoneName = 'America/Los_Angeles';
        break;
      default:
        timeZoneName = 'UTC';
    }

    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint("✅ Timezone: $timeZoneName (UTC+$offsetHours)");
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('UTC'));
      debugPrint("⚠️ Using UTC timezone");
    }
  }

  // Private: Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    debugPrint("🔔 Notification tapped: ${response.payload}");
  }
}
