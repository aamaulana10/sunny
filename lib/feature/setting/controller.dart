import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/core/service/notification/notification_manager.dart';
import 'package:sunny/feature/home/controller.dart';

class SettingController extends GetxController {
  late final SharedPreferences preferences;
  final notificationManager = NotificationManager.instance;

  RxBool isDarkMode = false.obs;
  RxInt morningHour = 10.obs;
  RxInt eveningHour = 20.obs;

  RxBool notifHeat = true.obs;
  RxBool notifRain = true.obs;
  RxBool notifDaily = true.obs;

  @override
  void onInit() async {
    preferences = await SharedPreferences.getInstance();
    checkDarkMode();
    loadHours();
    notifHeat.value = preferences.getBool('notif_heat') ?? true;
    notifRain.value = preferences.getBool('notif_rain') ?? true;
    notifDaily.value = preferences.getBool('notif_daily') ?? true;
    super.onInit();
  }

  Future<void> testNotification() async {
    try {
      notificationManager.showNow(title: 'title', body: 'body');
    } catch (e) {
      debugPrint('error notification ${e.toString()}');
      Get.snackbar("Title", "Message");
    }
  }

  Future<void> testScheduleNotification() async {
    try {
      notificationManager.scheduleDaily(
        id: 1,
        title: 'ini scheduled alert',
        body: 'body',
        hour: 21,
        minute: 17,
      );
    } catch (e) {
      debugPrint('error notification ${e.toString()}');
      Get.snackbar("Title", "Message");
    }
  }

  void setSwitchDarkMode(bool value) async {
    isDarkMode.value = value;

    preferences.setBool("isDarkMode", isDarkMode.value);

    debugPrint(isDarkMode.value.toString());
  }

  void checkDarkMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var darkMode = preferences.getBool("isDarkMode");

    debugPrint(darkMode.toString());

    isDarkMode.value = darkMode ?? false;
  }

  Future<void> loadHours() async {
    final prefs = await SharedPreferences.getInstance();

    morningHour.value = prefs.getInt('notif_hour_morning') ?? 10;
    eveningHour.value = prefs.getInt('notif_hour_evening') ?? 20;
  }

  Future<void> pickHour({required bool morning}) async {
    final initial = TimeOfDay(
      hour: morning ? morningHour.value : eveningHour.value,
      minute: 0,
    );
    final res = await showTimePicker(
      context: Get.context!,
      initialTime: initial,
    );
    if (res != null) {
      final prefs = await SharedPreferences.getInstance();
      if (morning) {
        await prefs.setInt('notif_hour_morning', res.hour);

        morningHour.value = res.hour;
      } else {
        await prefs.setInt('notif_hour_evening', res.hour);

        eveningHour.value = res.hour;
      }
    }
  }

  Future<void> rescheduleNow() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('notif_scheduled', false);
    try {
      final hc = Get.find<HomeController>();
      await hc.scheduleNotificationsNow();
      Get.snackbar(
        'Notifikasi',
        'Jadwal notifikasi diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.colorWidget,
        colorText: AppColors.textColorLight,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.schedule, color: Colors.lightBlueAccent),
      );
    } catch (_) {
      Get.snackbar(
        'Notifikasi',
        'Jadwal akan di-set pada fetch berikutnya',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.colorWidget,
        colorText: AppColors.textColorLight,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.info_outline, color: Colors.orangeAccent),
      );
    }
  }

  Future<void> setNotifHeat(bool v) async {
    notifHeat.value = v;
    await preferences.setBool('notif_heat', v);
    Get.snackbar(
      'Notifikasi',
      'Notifikasi cuaca panas ${v ? 'diaktifkan' : 'dimatikan'}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.colorWidget,
      colorText: AppColors.textColorLight,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.wb_sunny, color: Colors.yellowAccent),
    );
  }

  Future<void> setNotifRain(bool v) async {
    notifRain.value = v;
    await preferences.setBool('notif_rain', v);
    Get.snackbar(
      'Notifikasi',
      'Notifikasi cuaca hujan ${v ? 'diaktifkan' : 'dimatikan'}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.colorWidget,
      colorText: AppColors.textColorLight,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.cloud, color: Colors.blueAccent),
    );
  }

  Future<void> setNotifDaily(bool v) async {
    notifDaily.value = v;
    await preferences.setBool('notif_daily', v);
    Get.snackbar(
      'Notifikasi',
      'Notifikasi harian ${v ? 'diaktifkan' : 'dimatikan'}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.colorWidget,
      colorText: AppColors.textColorLight,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.access_time, color: Colors.lightBlueAccent),
    );
  }
}
