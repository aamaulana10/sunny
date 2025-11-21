import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:sunny/core/config/color/app_colors.dart';
import 'package:sunny/feature/home/controller.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  bool isDarkMode = false;
  int _morningHour = 10;
  int _eveningHour = 20;

  void usingFingerPrint() {
    print("finger print");
  }

  void setSwitchDarkMode(bool e) async {
    setState(() {
      isDarkMode = e;
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setBool("isDarkMode", isDarkMode);

    print(isDarkMode);
  }

  void checkDarkMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var darkMode = preferences.getBool("isDarkMode");

    print(darkMode);

    setState(() {
      isDarkMode = darkMode ?? false;
    });
  }

  void usingDarkMode() async {
    print("dark mode");
    setState(() {
      isDarkMode = !isDarkMode;
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setBool("isDarkMode", isDarkMode);

    var aa = preferences.getBool("isDarkMode");

    print(aa);
  }

  void saveLocation() {
    print("dark mode");
  }

  void exitApp() {
    print("dark mode");
  }

  @override
  void initState() {
    checkDarkMode();
    _loadHours();
    super.initState();
  }

  Future<void> _loadHours() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _morningHour = p.getInt('notif_hour_morning') ?? 10;
      _eveningHour = p.getInt('notif_hour_evening') ?? 20;
    });
  }

  Future<void> _pickHour({required bool morning}) async {
    final initial = TimeOfDay(
      hour: morning ? _morningHour : _eveningHour,
      minute: 0,
    );
    final res = await showTimePicker(context: context, initialTime: initial);
    if (res != null) {
      final p = await SharedPreferences.getInstance();
      if (morning) {
        await p.setInt('notif_hour_morning', res.hour);
        setState(() {
          _morningHour = res.hour;
        });
      } else {
        await p.setInt('notif_hour_evening', res.hour);
        setState(() {
          _eveningHour = res.hour;
        });
      }
    }
  }

  Future<void> _rescheduleNow() async {
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

  Widget settingList() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      padding: EdgeInsets.only(left: 8, right: 8),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 24),
            height: 80,
            child: InkWell(
              onTap: () => {this.usingFingerPrint()},
              child: Row(
                children: [
                  Icon(Icons.fingerprint, color: Colors.white),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Gunakan FingerPrint untuk membuka",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            child: InkWell(
              onTap: () => {this.usingDarkMode()},
              child: Row(
                children: [
                  Icon(Icons.nightlight_round, color: Colors.white),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(
                        "Dark Mode",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    child: Switch(
                      value: isDarkMode,
                      onChanged: (e) => {this.setSwitchDarkMode(e)},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            child: Row(
              children: [
                Icon(Icons.beach_access, color: Colors.white),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Heat Alert",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snap) {
                    final prefs = snap.data;
                    final val = prefs?.getBool('notif_heat') ?? true;
                    return Switch(
                      value: val,
                      onChanged: (e) async {
                        final p = await SharedPreferences.getInstance();
                        await p.setBool('notif_heat', e);
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            child: Row(
              children: [
                Icon(Icons.umbrella, color: Colors.white),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Rain Alert",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snap) {
                    final prefs = snap.data;
                    final val = prefs?.getBool('notif_rain') ?? true;
                    return Switch(
                      value: val,
                      onChanged: (e) async {
                        final p = await SharedPreferences.getInstance();
                        await p.setBool('notif_rain', e);
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            child: Row(
              children: [
                Icon(Icons.wb_sunny, color: Colors.white),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Daily Summary",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snap) {
                    final prefs = snap.data;
                    final val = prefs?.getBool('notif_daily') ?? true;
                    return Switch(
                      value: val,
                      onChanged: (e) async {
                        final p = await SharedPreferences.getInstance();
                        await p.setBool('notif_daily', e);
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            child: Row(
              children: [
                Icon(Icons.schedule, color: Colors.white),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Ringkasan Pagi: $_morningHour:00",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _pickHour(morning: true),
                  child: Text(
                    'Ubah',
                    style: TextStyle(color: AppColors.mainColor),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            child: Row(
              children: [
                Icon(Icons.nights_stay, color: Colors.white),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Ringkasan Malam: $_eveningHour:00",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _pickHour(morning: false),
                  child: Text(
                    'Ubah',
                    style: TextStyle(color: AppColors.mainColor),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
              ),
              onPressed: _rescheduleNow,
              child: Text('Jadwalkan Ulang Sekarang'),
            ),
          ),
          Container(
            height: 80,
            child: InkWell(
              onTap: () => {this.exitApp()},
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.white),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Exit app",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            alignment: Alignment.bottomCenter,
            child: Text(
              "Develop by: Aressa Labs",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.darkBackgroundColor,
      ),
      backgroundColor: AppColors.darkBackgroundColor,
      body: Container(child: settingList()),
    );
  }
}
