import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/core/utils/helper/condition_helper.dart';
import 'package:sunny/core/utils/helper/convert_helper.dart';
import 'package:sunny/feature/home/controller.dart';
import 'package:sunny/feature/mainTab/controller.dart';

class HomeTodayWidget extends StatelessWidget {
  final HomeController controller;
  const HomeTodayWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.weather.value?.hourly;

      return Column(
        children: [
          // Header
          Container(
            margin: const EdgeInsets.only(top: 8, right: 16, left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hari Ini",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NunitoBold',
                    color: AppColors.textLabelDark,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final tab = Get.find<MainTabController>();
                    tab.switchTab(2);
                  },
                  child: Text(
                    'Lihat Laporan',
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NunitoBold',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hourly card
          data != null
              ? SizedBox(
                height: 160,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // show 5 hours
                  itemBuilder: (context, index) {
                    final temp = data.temperature[index];
                    final weatherCode = data.weatherCode[index];
                    final timeString = data.time[index];
                    final rainProb =
                        data.precipitationProbability.isNotEmpty
                            ? data.precipitationProbability[index]
                            : 0;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.colorWidget,
                      ),
                      width: 90,
                      child: InkWell(
                        onTap: () { _showHourlyDetail(context, controller, index); },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              // ICON
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Image.asset(
                                  ConditionHelper.getIcon(weatherCode) ??
                                      'asset/image/thunderstorm.png',
                                  height: 53,
                                  width: 53,
                                ),
                              ),

                              // TIME
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 10,
                                      color: AppColors.mainColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      ConvertHelper.formatHourIso(timeString),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textColorLight,
                                        fontFamily: 'NunitoRegular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // TEMP
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Column(
                                  children: [
                                    Text(
                                      "${temp.toStringAsFixed(1)}°C",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColorLight,
                                        fontFamily: 'NunitoBold',
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Hujan $rainProb%",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textColorLight,
                                        fontFamily: 'NunitoRegular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
              : Container(),
        ],
      );
    });
  }

  void _showHourlyDetail(BuildContext context, HomeController c, int index) {
    final h = c.weather.value?.hourly;
    if (h == null) return;
    final temp = h.temperature[index];
    final code = h.weatherCode[index];
    final time = h.time[index];
    final rain = h.precipitationProbability.isNotEmpty ? h.precipitationProbability[index] : 0;
    final uv = h.uvIndex.isNotEmpty ? h.uvIndex[index] : 0;
    final wind = h.windspeed.isNotEmpty ? h.windspeed[index] : 0;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.colorWidget,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(ConditionHelper.getIcon(code) ?? 'asset/image/clearsky.png', width: 40, height: 40),
                  SizedBox(width: 12),
                  Text(ConvertHelper.formatHourIso(time), style: TextStyle(color: AppColors.textColorLight, fontFamily: 'NunitoBold', fontSize: 16)),
                  Spacer(),
                  Text("${temp.toStringAsFixed(1)}°C", style: TextStyle(color: AppColors.textColorLight, fontFamily: 'NunitoBold', fontSize: 18)),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _chip("Hujan", "$rain%"),
                  _chip("UV", uv.toStringAsFixed(1)),
                  _chip("Angin", "${wind.toStringAsFixed(1)} km/j"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.darkBackgroundColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: AppColors.textLabelDark, fontFamily: 'NunitoRegular', fontSize: 12)),
          SizedBox(width: 8),
          Text(value, style: TextStyle(color: AppColors.textColorLight, fontFamily: 'NunitoBold', fontSize: 12)),
        ],
      ),
    );
  }
}
