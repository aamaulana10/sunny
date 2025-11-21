import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny/core/model/weather_full_model.dart';
import 'package:sunny/core/service/weather_service.dart';

class HomeController extends GetxController {
  final WeatherService weatherService = WeatherService();

  Rxn<WeatherFullModel> weather = Rxn<WeatherFullModel>();
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
    Get.snackbar("Error", desc, snackPosition: SnackPosition.BOTTOM);
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
    } catch (e) {
      await _loadCached(latitude, longitude);
      Get.snackbar("Error", "Gagal mendapatkan cuaca");
    }
  }

  Future<void> _cacheWeather(
    String latitude,
    String longitude,
    WeatherFullModel data,
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
        weather.value = WeatherFullModel.fromJson(map);
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
}
