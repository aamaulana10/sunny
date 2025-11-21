import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sunny/core/config/color/app_colors.dart';
import 'package:sunny/core/config/helper/condition_helper.dart';
import 'package:sunny/core/config/helper/convert_helper.dart';
import 'package:sunny/feature/home/controller.dart';

class WeatherListView extends StatefulWidget {
  const WeatherListView({super.key});

  @override
  State<WeatherListView> createState() => _WeatherListViewState();
}

class _WeatherListViewState extends State<WeatherListView> {

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: AppColors.darkBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            await home.getCurrentLocation();
          },
          child: Obx(() {
            if (home.isLoading.isTrue) {
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
            final weather = home.weather.value;
            if (weather == null) return Container();
            final hourly = weather.hourly;
            final daily = weather.daily;
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Per Jam",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NunitoBold',
                          color: AppColors.textLabelDark,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hourly.temperature.length >= 12 ? 12 : hourly.temperature.length,
                        itemBuilder: (context, index) {
                          final temp = hourly.temperature[index];
                          final code = hourly.weatherCode[index];
                          final time = hourly.time[index];
                          final rain = hourly.precipitationProbability.isNotEmpty ? hourly.precipitationProbability[index] : 0;
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.colorWidget,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    ConditionHelper.getIcon(code) ?? 'asset/image/fluenttemperature.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.access_time_rounded, size: 10, color: AppColors.mainColor),
                                      SizedBox(width: 4),
                                      Text(
                                        ConvertHelper.formatHourIso(time),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textColorLight,
                                          fontFamily: 'NunitoRegular',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
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
                                    "Hujan ${rain}%",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textColorLight,
                                      fontFamily: 'NunitoRegular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        "7 Hari",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NunitoBold',
                          color: AppColors.textLabelDark,
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: daily.time.length,
                      itemBuilder: (context, index) {
                        final dt = DateTime.tryParse(daily.time[index]);
                        final dayText = dt != null ? DateFormat('EEEE', 'id_ID').format(dt) : daily.time[index];
                        final dateText = dt != null ? DateFormat('MMM, dd', 'id_ID').format(dt) : '';
                        final code = daily.weatherCode[index];
                        final tMax = daily.temperatureMax[index];
                        final tMin = daily.temperatureMin[index];
                        final uv = daily.uvIndexMax.isNotEmpty ? daily.uvIndexMax[index] : 0;
                        final sunrise = daily.sunrise.isNotEmpty ? daily.sunrise[index] : '';
                        final sunset = daily.sunset.isNotEmpty ? daily.sunset[index] : '';
                        return InkWell(
                          onTap: () { _showDailyDetail(context, daily, index, hourly); },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 1, color: Color(0XFF313131))),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                              SizedBox(
                                width: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dayText,
                                      style: TextStyle(
                                        color: AppColors.textColorLight,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'NunitoBold',
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      dateText,
                                      style: TextStyle(
                                        color: AppColors.textColorLight,
                                        fontSize: 12,
                                        fontFamily: 'NunitoRegular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage("asset/image/fluenttemperature.png"),
                                      height: 24,
                                      width: 24,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "${tMax.toStringAsFixed(1)}°C / ${tMin.toStringAsFixed(1)}°C",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: AppColors.textColorLight,
                                        fontFamily: 'NunitoBold',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Image(
                                    image: AssetImage(ConditionHelper.getIcon(code) ?? "asset/image/clearsky.png"),
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "UV ${uv.toStringAsFixed(1)}",
                                    style: TextStyle(
                                      color: AppColors.textLabelDark,
                                      fontSize: 12,
                                      fontFamily: 'NunitoRegular',
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${ConvertHelper.formatTimeIso(sunrise)} / ${ConvertHelper.formatTimeIso(sunset)}",
                                    style: TextStyle(
                                      color: AppColors.textLabelDark,
                                      fontSize: 12,
                                      fontFamily: 'NunitoRegular',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ));
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showDailyDetail(BuildContext context, dynamic daily, int index, dynamic hourly) {
    final code = daily.weatherCode[index];
    final day = daily.time[index];
    final tMax = daily.temperatureMax[index];
    final tMin = daily.temperatureMin[index];
    final uv = daily.uvIndexMax.isNotEmpty ? daily.uvIndexMax[index] : 0;
    final sunrise = daily.sunrise.isNotEmpty ? daily.sunrise[index] : '';
    final sunset = daily.sunset.isNotEmpty ? daily.sunset[index] : '';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.colorWidget,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(ConditionHelper.getIcon(code) ?? 'asset/image/clearsky.png', width: 40, height: 40),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('EEEE, dd MMM', 'id_ID').format(DateTime.parse(day)), style: TextStyle(color: AppColors.textColorLight, fontFamily: 'NunitoBold', fontSize: 16)),
                        SizedBox(height: 4),
                        Text("${tMax.toStringAsFixed(1)}°C / ${tMin.toStringAsFixed(1)}°C", style: TextStyle(color: AppColors.textColorLight, fontFamily: 'NunitoBold', fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _chip("UV", uv.toStringAsFixed(1)),
                  _chip("Sunrise", ConvertHelper.formatTimeIso(sunrise)),
                  _chip("Sunset", ConvertHelper.formatTimeIso(sunset)),
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
