import 'package:flutter/material.dart';
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
          // Padding(
          //   padding: EdgeInsets.only(top: 24, bottom: 8),
          //   child: Text(
          //     'Tampilan',
          //     style: TextStyle(
          //       color: AppColors.textColorLight,
          //       fontSize: 16,
          //       fontFamily: 'NunitoBold',
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 80,
          //   child: Row(
          //     children: [
          //       Icon(Icons.nightlight_round, color: Colors.white),
          //       Expanded(
          //         child: Container(
          //           margin: EdgeInsets.only(left: 8),
          //           child: Text(
          //             "Dark Mode",
          //             style: TextStyle(color: Colors.white),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 70,
          //         child: Switch(
          //           value: controller.isDarkMode.value,
          //           onChanged: (e) => controller.setSwitchDarkMode(e),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'Notifikasi',
              style: TextStyle(
                color: AppColors.textColorLight,
                fontSize: 16,
                fontFamily: 'NunitoBold',
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
                Obx(
                  () => Switch(
                    value: controller.notifHeat.value,
                    onChanged: (e) => controller.setNotifHeat(e),
                  ),
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
                Obx(
                  () => Switch(
                    value: controller.notifRain.value,
                    onChanged: (e) => controller.setNotifRain(e),
                  ),
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
                Obx(
                  () => Switch(
                    value: controller.notifDaily.value,
                    onChanged: (e) => controller.setNotifDaily(e),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'Jadwal Ringkasan',
              style: TextStyle(
                color: AppColors.textColorLight,
                fontSize: 16,
                fontFamily: 'NunitoBold',
              ),
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
    final controller = Get.find<SettingController>();
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final bg =
          isDark
              ? AppColors.darkBackgroundColor
              : AppColors.lightBackgroundColor;
      final titleColor = isDark ? Colors.white : Colors.black;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Setting",
            style: TextStyle(
              color: titleColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: bg,
        ),
        backgroundColor: bg,
        body: Container(child: settingList()),
      );
    });
  }
}
