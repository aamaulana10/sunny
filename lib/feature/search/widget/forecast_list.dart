import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sunny/core/config/color/app_colors.dart';
import 'package:sunny/core/config/helper/condition_helper.dart';
import 'package:sunny/feature/search/controller.dart';

class NextForecastList extends StatelessWidget {
  final Function(int)? onTapItem;

  const NextForecastList({
    super.key,
    this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchViewController>();

    return Obx(() {
      // Loading State
      if (controller.isLoading.value) {
        return SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainColor),
            ),
          ),
        );
      }

      // Check if data available
      final weather = controller.weather.value;
      if (weather == null || weather.daily.time.isEmpty) {
        return Center(
          child: Text(
            "Data tidak ditemukan",
            style: TextStyle(
              color: AppColors.textLabelColor,
              fontFamily: 'NunitoRegular',
            ),
          ),
        );
      }

      final daily = weather.daily;
      final itemCount = daily.time.length;

      return Container(
        margin: const EdgeInsets.only(top: 0, left: 8, right: 8),
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // Parse data untuk setiap item
            final date = DateTime.parse(daily.time[index]);
            final tempMax = daily.temperatureMax[index];
            final weatherCode = daily.weatherCode[index];

            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Color(0XFF313131)),
                ),
              ),
              margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: InkWell(
                onTap: () {
                  if (onTapItem != null) {
                    onTapItem!(index);
                  }
                },
                highlightColor: AppColors.mainColor.withOpacity(.2),
                splashColor: AppColors.mainColor.withOpacity(.2),
                child: Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Row(
                    children: [
                      // Date Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEEE').format(date),
                            style: TextStyle(
                              color: AppColors.textColorLight,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NunitoBold',
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('MMM, dd').format(date),
                              style: TextStyle(
                                color: AppColors.textColorLight,
                                fontSize: 12,
                                fontFamily: 'NunitoRegular',
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Temperature (Center)
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage(
                                "asset/image/fluenttemperature.png",
                              ),
                              height: 26,
                              width: 26,
                            ),
                            Text(
                              "${tempMax.toStringAsFixed(1)}°C",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: AppColors.textColorLight,
                                fontFamily: 'NunitoBold',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Weather Icon
                      Image(
                        image: AssetImage(
                          ConditionHelper.getIcon(weatherCode) ??
                              "asset/image/fluenttemperature.png",
                        ),
                        width: 53,
                        height: 53,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
