import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/core/config/color/app_colors.dart';
import 'package:sunny/core/config/helper/condition_helper.dart';
import 'package:sunny/core/config/helper/convert_helper.dart';
import 'package:sunny/core/model/weather_full_model.dart';
import 'package:sunny/feature/home/controller.dart';

class HomeWeatherWidget extends StatelessWidget {
  final HomeController controller;
  const HomeWeatherWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
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

      /// DATA
      final weather = controller.weather.value;
      if (weather == null) return Container();

      final current = weather.current;
      final daily = weather.daily;

      final temp = current.temperature;
      final wind = current.windSpeed;
      final humidity = weather.hourly.humidity.first;
      final rainProb =
          weather.hourly.precipitationProbability.isNotEmpty
              ? weather.hourly.precipitationProbability.first
              : 0;
      final uvMax = daily.uvIndexMax.isNotEmpty ? daily.uvIndexMax.first : 0;
      final sunrise = daily.sunrise.isNotEmpty ? daily.sunrise.first : '';
      final sunset = daily.sunset.isNotEmpty ? daily.sunset.first : '';

      final condition = ConditionHelper.getCondition(current.weatherCode);
      final mood = ConditionHelper.getMoodMessage(current.weatherCode);

      return Column(
        children: [
          /// ICON
          Container(
            margin: EdgeInsets.only(top: 16),
            child: AvatarGlow(
              glowColor: _themeColor(current.weatherCode),
              duration: Duration(milliseconds: 3000),
              repeat: true,
              animate: true,
              child: Image(
                height: 200,
                width: 200,
                image: AssetImage(
                  condition["icon"] ?? "asset/image/clearsky.png",
                ),
              ),
            ),
          ),

          /// TEMP
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("asset/image/fluenttemperature.png"),
                  height: 36,
                  width: 36,
                ),
                Text(
                  "${temp.toStringAsFixed(1)}°C",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLabelDark,
                    fontFamily: 'NunitoBold',
                  ),
                ),
              ],
            ),
          ),

          /// DESCRIPTION
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Column(
              children: [
                Text(
                  condition["description"] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLabelDark,
                    fontFamily: 'NunitoSemiBold',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  mood,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLabelDark,
                    fontFamily: 'NunitoRegular',
                  ),
                ),
              ],
            ),
          ),

          /// FORECAST / WIND
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child:
                controller.isForecast.isTrue
                    ? _buildDailyForecast(daily)
                    : Column(
                      children: [
                        _buildWindHumidity(wind, humidity),
                        _buildRainUv(rainProb, uvMax),
                        _buildSunriseSunset(sunrise, sunset),
                      ],
                    ),
          ),
        ],
      );
    });
  }

  Widget _buildDailyForecast(DailyWeather daily) {
    if (daily.time.isEmpty) return Container();

    final firstDayCode = daily.weatherCode.first;
    final firstTemp = daily.temperatureMax.first;
    final firstDay = daily.time.first;

    final cond = ConditionHelper.getCondition(firstDayCode);

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _dailyItem(cond["icon"], firstDay, firstTemp),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(horizontal: 32),
          ),
          _dailyItem(cond["icon"], firstDay, firstTemp),
        ],
      ),
    );
  }

  Widget _dailyItem(String? icon, String day, double temp) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: Image(
            image: AssetImage(icon ?? 'asset/image/clearsky.png'),
            height: 40,
            width: 40,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ConvertHelper.formatHourIso(day),
              style: TextStyle(
                color: AppColors.textColorLight,
                fontSize: 12,
                fontFamily: 'NunitoRegular',
              ),
            ),
            Row(
              children: [
                Image(
                  image: AssetImage("asset/image/fluenttemperature.png"),
                  height: 20,
                  width: 20,
                ),
                Text(
                  "${temp.toStringAsFixed(1)}°C",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorLight,
                    fontFamily: 'NunitoBold',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWindHumidity(double wind, int humidity) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _infoItem(
            "Kecepatan Angin",
            "asset/image/windspeed.png",
            "asset/image/speed.png",
            "$wind km/j",
          ),
          Container(
            width: 1,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.colorGrey,
          ),
          _infoItem(
            "Kelembapan",
            "asset/image/humidity.png",
            "asset/image/waterpercent.png",
            "$humidity%",
          ),
        ],
      ),
    );
  }

  Widget _buildRainUv(int rainProb, num uvMax) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _infoItem(
            "Peluang Hujan",
            "asset/image/showerrain.png",
            "asset/image/showerrain.png",
            "$rainProb%",
          ),
          Container(
            width: 1,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.colorGrey,
          ),
          _infoItem(
            "UV Index",
            "asset/image/sunny.png",
            "asset/image/sunny.png",
            uvMax.toStringAsFixed(1),
          ),
        ],
      ),
    );
  }

  Widget _buildSunriseSunset(String sunrise, String sunset) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sunrise ${ConvertHelper.formatTimeIso(sunrise)}",
            style: TextStyle(
              color: AppColors.textLabelDark,
              fontFamily: 'NunitoRegular',
            ),
          ),
          SizedBox(width: 16),
          Text(
            "Sunset ${ConvertHelper.formatTimeIso(sunset)}",
            style: TextStyle(
              color: AppColors.textLabelDark,
              fontFamily: 'NunitoRegular',
            ),
          ),
        ],
      ),
    );
  }

  Color _themeColor(int code) {
    if (code == 0) return Colors.amberAccent;
    if (code == 1 || code == 2) return Colors.blueAccent;
    if (code == 3) return Colors.blueGrey;
    if ([61, 63, 65, 80, 81, 82].contains(code)) return Colors.lightBlueAccent;
    if ([95, 96, 99].contains(code)) return Colors.deepPurpleAccent;
    return AppColors.mainColor;
  }

  Widget _infoItem(
    String label,
    String iconBig,
    String iconSmall,
    String value,
  ) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: Image(image: AssetImage(iconBig), height: 40, width: 40),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.textColorLight,
                fontSize: 12,
                fontFamily: 'NunitoRegular',
              ),
            ),
            Row(
              children: [
                Image(image: AssetImage(iconSmall), height: 20, width: 20),
                SizedBox(width: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorLight,
                    fontFamily: 'NunitoBold',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
