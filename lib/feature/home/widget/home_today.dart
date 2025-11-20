import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/core/config/color/app_colors.dart';
import 'package:sunny/core/config/helper/condition_helper.dart';
import 'package:sunny/core/config/helper/convert_helper.dart';
import 'package:sunny/feature/home/controller.dart';

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
                  onPressed: () {},
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
                height: 135,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // show 5 hours
                  itemBuilder: (context, index) {
                    final temp = data.temperature[index];
                    final weatherCode = data.weatherCode[index];
                    final timeString = data.time[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.colorWidget,
                      ),
                      width: 90,
                      child: InkWell(
                        onTap: () {},
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
                                child: Text(
                                  "${temp.toStringAsFixed(1)}°C",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColorLight,
                                    fontFamily: 'NunitoBold',
                                  ),
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
}
