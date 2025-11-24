import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/core/utils/helper/condition_helper.dart';
import 'package:sunny/core/service/notification/notification_manager.dart';
import 'package:sunny/feature/weather/model/weather_model.dart';
import 'package:sunny/feature/weather/repository.dart';

class HomeController extends GetxController {
  final WeatherService weatherService = WeatherService();

  Rxn<WeatherModel> weather = Rxn<WeatherModel>();
  RxBool isLoading = true.obs;
  RxString address = "Mendapatkan Lokasimu".obs;
  RxBool isForecast = true.obs;
  RxInt streak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initializeDateFormatting();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;

      // Permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _failLocation("Lokasi tidak aktif", "Mohon aktifkan layanan lokasi");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _failLocation("Akses lokasi ditolak", "Izin lokasi diperlukan");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _failLocation(
          "Akses lokasi ditolak permanen",
          "Mohon aktifkan izin lokasi di pengaturan",
        );
        return;
      }

      // Ambil posisi
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      // Address
      await _getAddressFromLatLng(position.latitude, position.longitude);

      // Forecast
      await getForecast(
        position.latitude.toString(),
        position.longitude.toString(),
      );

      isLoading.value = false;
    } catch (e) {
      debugPrint("Error getCurrentLocation: $e");
      _failLocation("Gagal mendapatkan lokasi", e.toString());
    }
  }

  void _failLocation(String msg, String desc) {
    address.value = msg;
    isLoading.value = false;
    Get.snackbar(
      "Error",
      desc,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.colorWidget,
      colorText: AppColors.textColorLight,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.redAccent),
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<geo.Placemark> data = await geo.placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (data.isNotEmpty) {
        final place = data[0];

        address.value =
            place.locality?.isNotEmpty == true
                ? "${place.locality}, ${place.country}"
                : place.subAdministrativeArea?.isNotEmpty == true
                ? "${place.subAdministrativeArea}, ${place.country}"
                : "${place.country}";
      }
    } catch (e) {
      address.value = "Lokasi tidak diketahui";
    }
  }

  Future<void> getForecast(String latitude, String longitude) async {
    try {
      final data = await weatherService.getWeatherByLatLong(
        latitude,
        longitude,
      );
      weather.value = data;
      await _cacheWeather(latitude, longitude, data);
      await _updateStreak();
      await _maybeNotify(data);
      await _scheduleFirstTime(data);
    } catch (e) {
      debugPrint('error ${e.toString()}');
      await _loadCached(latitude, longitude);
      if (weather.value != null) {
        Get.snackbar(
          "Offline",
          "You're offline — menampilkan data tersimpan",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.darkBackgroundColor,
          colorText: AppColors.textColorLight,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.cloud_off, color: Colors.orangeAccent),
        );
      } else {
        Get.snackbar(
          "Error",
          "Gagal mendapatkan cuaca",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.colorWidget,
          colorText: AppColors.textColorLight,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.error_outline, color: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _cacheWeather(
    String latitude,
    String longitude,
    WeatherModel data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "cache_weather_${latitude}_$longitude";
    await prefs.setString(key, data.toJson().toString());
    await prefs.setString(
      "cache_weather_last_time",
      DateTime.now().toIso8601String(),
    );
  }

  Future<void> _loadCached(String latitude, String longitude) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "cache_weather_${latitude}_$longitude";
    final cached = prefs.getString(key);
    if (cached != null) {
      try {
        final map = jsonDecode(cached) as Map<String, dynamic>;
        weather.value = WeatherModel.fromJson(map);
      } catch (_) {}
    }
  }

  Future<void> _updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final lastStr = prefs.getString("last_streak_date");
    final last = lastStr != null ? DateTime.tryParse(lastStr) : null;

    int current = prefs.getInt("daily_streak") ?? 0;

    if (last == null) {
      current = 1;
    } else {
      final diff =
          today.difference(DateTime(last.year, last.month, last.day)).inDays;
      if (diff == 0) {
        // same day, keep
      } else if (diff == 1) {
        current += 1;
      } else {
        current = 1;
      }
    }

    await prefs.setInt("daily_streak", current);
    await prefs.setString("last_streak_date", today.toIso8601String());
    streak.value = current;
  }

  Future<void> _maybeNotify(WeatherModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final rainEnabled = prefs.getBool('notif_rain') ?? true;
    final heatEnabled = prefs.getBool('notif_heat') ?? true;
    final dailyEnabled = prefs.getBool('notif_daily') ?? true;

    final rainProb =
        data.hourly.precipitationProbability.isNotEmpty
            ? data.hourly.precipitationProbability.first
            : 0;
    final temp = data.current.temperature;

    if (rainEnabled && rainProb >= 60) {
      Get.snackbar(
        'Rain Alert',
        'Bawa payung bro, bakal hujan bentar lagi 😭',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.colorWidget,
        colorText: AppColors.textColorLight,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.umbrella, color: Colors.lightBlueAccent),
      );
    }
    if (heatEnabled && temp >= 32) {
      Get.snackbar(
        'Heat Alert',
        'UV tinggi — sunscreen dulu ya!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.colorWidget,
        colorText: AppColors.textColorLight,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.wb_sunny_outlined, color: Colors.amber),
      );
    }
    if (dailyEnabled) {
      // can be scheduled via _scheduleFirstTime
    }
  }

  Future<void> _scheduleFirstTime(WeatherModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final scheduled = prefs.getBool('notif_scheduled') ?? false;
    if (scheduled) return;

    final morningHour = prefs.getInt('notif_hour_morning') ?? 10;
    final eveningHour = prefs.getInt('notif_hour_evening') ?? 20;

    final todayTitle =
        "Cuaca hari ini ${ConditionHelper.getDescription(data.current.weatherCode) ?? ''}";
    final todayBody =
        "Temperaturnya ${data.current.temperature.toStringAsFixed(1)}°C";

    await NotificationManager.instance.scheduleDaily(
      id: 100,
      title: todayTitle,
      body: todayBody,
      hour: morningHour,
      minute: 00
    );

    if (data.daily.time.length > 1) {
      final codeTomorrow = data.daily.weatherCode[1];
      final tomorrowTitle =
          "Cuaca besok ${ConditionHelper.getDescription(codeTomorrow) ?? ''}";
      final tomorrowBody =
          "Maks ${data.daily.temperatureMax[1].toStringAsFixed(1)}°C / Min ${data.daily.temperatureMin[1].toStringAsFixed(1)}°C";
      await NotificationManager.instance.scheduleDaily(
        id: 101,
        title: tomorrowTitle,
        body: tomorrowBody,
        hour: eveningHour,
        minute: 00
      );
    }

    await prefs.setBool('notif_scheduled', true);
  }

  Future<void> scheduleNotificationsNow() async {
    if (weather.value == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_scheduled', false);
    await _scheduleFirstTime(weather.value!);
  }
}
