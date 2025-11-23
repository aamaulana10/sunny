import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/feature/search/controller.dart';

class WeatherColumnWidget extends StatelessWidget {
  const WeatherColumnWidget({super.key});

  Widget _buildWeatherCard({
    required BuildContext context,
    required double top,
    double? left,
    double? right,
    required String temp,
    required String condition,
    required String location,
    required String icon,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.colorWidget,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8, right: 8, top: 16),
              height: 60,
              width: (MediaQuery.of(context).size.width / 2) - 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temp,
                        style: TextStyle(
                          color: AppColors.textColorLight,
                          fontSize: 22,
                          fontFamily: 'NunitoBold',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        condition,
                        style: TextStyle(
                          color: AppColors.textColorLight,
                          fontSize: 14,
                          fontFamily: 'NunitoRegular',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Image.asset(icon, width: 45, height: 45, fit: BoxFit.fill),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                location,
                style: TextStyle(color: AppColors.textColorLight, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================
  // Mapping WeatherCode → Icon
  // ==========================
  String _mapWeatherCodeToIcon(int code) {
    if (code == 0) return "asset/image/sunny.png";
    if (code == 1 || code == 2) return "asset/image/fewclouds.png";
    if (code == 3) return "asset/image/brokenclouds.png";
    if (code == 45 || code == 48) return "asset/image/mist.png";
    if ([51, 53, 55].contains(code)) return "asset/image/sunny.png";
    if ([61, 63, 65].contains(code)) return "asset/image/rain.png";
    if ([71, 73, 75].contains(code)) return "asset/image/snow.png";
    if ([95, 96, 99].contains(code)) return "asset/image/thunderstorm.png";

    return "asset/image/sunny.png";
  }

  String _mapWeatherCodeToText(int code) {
    if (code == 0) return "Clear Sky";
    if (code == 1 || code == 2) return "Partly Cloudy";
    if (code == 3) return "Cloudy";
    if (code == 45 || code == 48) return "Fog";
    if ([51, 53, 55].contains(code)) return "Drizzle";
    if ([61, 63, 65].contains(code)) return "Rain";
    if ([71, 73, 75].contains(code)) return "Snow";
    if ([95, 96, 99].contains(code)) return "Thunderstorm";

    return "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchViewController>();

    return Obx(() {
      final data = controller.weather.value;

      if (data == null || data.hourly.time.isEmpty) {
        return const SizedBox();
      }

      final hourly = data.hourly;
      final location =
          controller.locationInput.value.isNotEmpty
              ? controller.locationInput.value
              : controller.cityFromAddress.value;

      // Safety: perlu minimal 4 data
      if (hourly.temperature.length < 4) return const SizedBox();

      return SizedBox(
        height: 400,
        child: Stack(
          children: [
            _buildWeatherCard(
              context: context,
              top: 8,
              left: 16,
              temp: "${hourly.temperature[0].toStringAsFixed(1)}°",
              condition: _mapWeatherCodeToText(hourly.weatherCode[0]),
              location: location,
              icon: _mapWeatherCodeToIcon(hourly.weatherCode[0]),
            ),

            _buildWeatherCard(
              context: context,
              top: 32,
              right: 16,
              temp: "${hourly.temperature[1].toStringAsFixed(1)}°",
              condition: _mapWeatherCodeToText(hourly.weatherCode[1]),
              location: location,
              icon: _mapWeatherCodeToIcon(hourly.weatherCode[1]),
            ),

            _buildWeatherCard(
              context: context,
              top: 120,
              left: 16,
              temp: "${hourly.temperature[2].toStringAsFixed(1)}°",
              condition: _mapWeatherCodeToText(hourly.weatherCode[2]),
              location: location,
              icon: _mapWeatherCodeToIcon(hourly.weatherCode[2]),
            ),

            _buildWeatherCard(
              context: context,
              top: 144,
              right: 16,
              temp: "${hourly.temperature[3].toStringAsFixed(1)}°",
              condition: _mapWeatherCodeToText(hourly.weatherCode[3]),
              location: location,
              icon: _mapWeatherCodeToIcon(hourly.weatherCode[3]),
            ),
          ],
        ),
      );
    });
  }
}
