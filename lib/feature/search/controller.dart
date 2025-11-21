import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
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
          "Error",
          "Mohon aktifkan layanan lokasi",
          snackPosition: SnackPosition.BOTTOM,
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
            "Error",
            "Izin akses lokasi diperlukan",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        address.value = "Izin lokasi ditolak permanen";
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "Mohon aktifkan izin lokasi di pengaturan",
          snackPosition: SnackPosition.BOTTOM,
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
