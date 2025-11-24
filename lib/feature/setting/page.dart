import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/feature/setting/controller.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Widget settingList() {
    final controller = Get.find<SettingController>();

    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      padding: EdgeInsets.only(left: 8, right: 8),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 24),
            height: 80,
            child: InkWell(
              onTap: () => {controller.testNotification()},
              child: Row(
                children: [
                  Icon(Icons.fingerprint, color: Colors.white),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Test notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24),
            height: 80,
            child: InkWell(
              onTap: () => {controller.testScheduleNotification()},
              child: Row(
                children: [
                  Icon(Icons.fingerprint, color: Colors.white),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Test scheduled notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 80,
            child: InkWell(
              onTap: () => {controller.usingDarkMode()},
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
                  SizedBox(
                    width: 70,
                    child: Switch(
                      value: controller.isDarkMode.value,
                      onChanged: (e) => {controller.setSwitchDarkMode(e)},
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
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
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
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
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
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
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Icon(Icons.schedule, color: Colors.white),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Ringkasan Pagi: ${controller.morningHour.value}:00",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => controller.pickHour(morning: true),
                  child: Text(
                    'Ubah',
                    style: TextStyle(color: AppColors.mainColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Icon(Icons.nights_stay, color: Colors.white),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Ringkasan Malam: ${controller.eveningHour.value}:00",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => controller.pickHour(morning: false),
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
              onPressed: controller.rescheduleNow,
              child: Text('Jadwalkan Ulang Sekarang'),
            ),
          ),
          SizedBox(
            height: 80,
            child: InkWell(
              onTap: () => {controller.exitApp()},
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
