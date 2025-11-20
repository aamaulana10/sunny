import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sunny/core/model/weather_full_model.dart';
import 'package:sunny/core/service/weather_service.dart';

class HomeController extends GetxController {
  final WeatherService weatherService = WeatherService();

  Rxn<WeatherFullModel> weather = Rxn<WeatherFullModel>();
  RxBool isLoading = true.obs;
  RxString address = "Mendapatkan Lokasimu".obs;
  RxBool isForecast = true.obs;

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
      weather.value = await weatherService.getWeatherByLatLong(
        latitude,
        longitude,
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal mendapatkan cuaca");
    }
  }
}
