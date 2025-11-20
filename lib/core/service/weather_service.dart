import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sunny/core/model/weather_full_model.dart';

class WeatherService {
  static const geocodingUrl = "https://geocoding-api.open-meteo.com/v1/search";
  static const weatherUrl = "https://api.open-meteo.com/v1/forecast";

  /// Search city → get coordinates → fetch weather
  Future<WeatherFullModel> getWeatherByCity(String city) async {
    final geoRes = await http.get(Uri.parse("$geocodingUrl?name=$city"));

    final geoData = jsonDecode(geoRes.body);

    if (geoData['results'] == null || geoData['results'].isEmpty) {
      throw Exception("City not found");
    }

    final lat = geoData['results'][0]['latitude'];
    final lon = geoData['results'][0]['longitude'];

    return getWeatherByLatLong(lat.toString(), lon.toString());
  }

  /// Main Weather API (current + hourly + daily)
  Future<WeatherFullModel> getWeatherByLatLong(String lat, String lon) async {
    final url =
        "$weatherUrl?latitude=$lat&longitude=$lon"
        "&current_weather=true"
        "&hourly=temperature_2m,relative_humidity_2m,weathercode"
        "&daily=weathercode,temperature_2m_max,temperature_2m_min"
        "&timezone=auto";

    final res = await http.get(Uri.parse(url));

    final data = jsonDecode(res.body);

    return WeatherFullModel.fromJson(data);
  }
}
