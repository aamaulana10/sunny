import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny/core/config/color/app_colors.dart';
import 'package:sunny/core/model/weather_full_model.dart';
import 'package:sunny/core/service/weather_service.dart';

class SearchViewController extends GetxController {
  final WeatherService weatherService = WeatherService();

  Rxn<WeatherFullModel> weather = Rxn<WeatherFullModel>();
  RxBool isLoading = false.obs;
  RxBool isSearch = false.obs;

  RxString address = "Mendapatkan Lokasimu".obs;
  RxString cityFromAddress = "".obs;
  RxString locationInput = "".obs;
  RxList<String> recentSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    _loadRecents();
  }

  Future<void> _loadRecents() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('recent_searches') ?? [];
    recentSearches.assignAll(list);
  }

  Future<void> _addRecent(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('recent_searches') ?? [];
    list.remove(city);
    list.insert(0, city);
    final trimmed = list.length > 5 ? list.sublist(0, 5) : list;
    await prefs.setStringList('recent_searches', trimmed);
    recentSearches.assignAll(trimmed);
  }

  void setInputLocation(String location) {
    locationInput.value = location;
    isSearch.value = false;
  }

  // ============================================================
  // 🔥 Ambil Lokasi User (GPS)
  // ============================================================
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;

      // cek service aktif ga
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        address.value = "Lokasi tidak aktif";
        isLoading.value = false;
        Get.snackbar(
          "Lokasi Tidak Aktif",
          "Mohon aktifkan layanan lokasi",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.colorWidget,
          colorText: AppColors.textColorLight,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.location_off, color: Colors.orangeAccent),
        );
        return;
      }

      // cek permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          address.value = "Akses lokasi ditolak";
          isLoading.value = false;
          Get.snackbar(
            "Izin Diperlukan",
            "Izin akses lokasi diperlukan",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.colorWidget,
            colorText: AppColors.textColorLight,
            margin: const EdgeInsets.all(12),
            borderRadius: 12,
            icon: const Icon(Icons.lock_open, color: Colors.lightBlueAccent),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        address.value = "Izin lokasi ditolak permanen";
        isLoading.value = false;
        Get.snackbar(
          "Izin Ditolak Permanen",
          "Mohon aktifkan izin lokasi di pengaturan",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.colorWidget,
          colorText: AppColors.textColorLight,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.settings, color: Colors.orangeAccent),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      debugPrint("Position: ${pos.latitude}, ${pos.longitude}");

      await _getAddressFromLatLng(pos.latitude, pos.longitude);
      await getForecast(pos.latitude, pos.longitude);

      isLoading.value = false;
    } catch (e) {
      debugPrint("Error lokasi: $e");
      address.value = "Gagal mendapatkan lokasi";
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Gagal mendapatkan lokasi: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // 🔥 Convert Koordinat → Nama Kota
  // ============================================================
  Future<void> _getAddressFromLatLng(double lat, double lon) async {
    try {
      final place = await geo.placemarkFromCoordinates(lat, lon);

      if (place.isNotEmpty) {
        final data = place.first;

        final city =
            data.locality?.isNotEmpty == true
                ? data.locality!
                : data.subAdministrativeArea ?? "Unknown";

        cityFromAddress.value = city;
        address.value = "$city, ${data.country}";
      }
    } catch (e) {
      debugPrint("Error address: $e");
      address.value = "Lokasi tidak diketahui";
    }
  }

  // ============================================================
  // 🔥 Ambil Data Cuaca dari Open-Meteo
  // ============================================================
  Future<void> getForecast(double lat, double lon) async {
    try {
      isLoading.value = true;
      weather.value = await weatherService.getWeatherByLatLong(
        lat.toString(),
        lon.toString(),
      );
      isLoading.value = false;
    } catch (e) {
      debugPrint("Error forecast: $e");
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Gagal mendapatkan cuaca",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // 🔥 Search kota → geocode → forecast
  // ============================================================
  Future<void> getCurrentWeather(String city) async {
    try {
      isSearch.value = true;
      isLoading.value = true;

      final geoResult = await geo.locationFromAddress(city);

      if (geoResult.isEmpty) {
        throw Exception("Lokasi tidak ditemukan");
      }

      final lat = geoResult.first.latitude;
      final lon = geoResult.first.longitude;

      address.value = city;

      await getForecast(lat, lon);
      await _addRecent(city);

      isLoading.value = false;
    } catch (e) {
      debugPrint("Error search: $e");
      isLoading.value = false;
      weather.value = null;

      Get.snackbar(
        "Error",
        "Lokasi tidak ditemukan",
        backgroundColor: AppColors.lightBackgroundColor,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
