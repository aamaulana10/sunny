import 'package:sunny/core/network/network_client.dart';
import 'package:sunny/feature/weather/model/weather_full_model.dart';

class WeatherService {
  final NetworkClient client = NetworkClient();
  static const geocodingUrl = "https://geocoding-api.open-meteo.com/v1/search";
  static const weatherUrl = "https://api.open-meteo.com/v1/forecast";

  /// Search city → get coordinates → fetch weather
  Future<WeatherFullModel> getWeatherByCity(String city) async {
    final geoData = await client.get("$geocodingUrl?name=$city");

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
        "&hourly=temperature_2m,apparent_temperature,relative_humidity_2m,weathercode,precipitation_probability,precipitation,uv_index,windspeed_10m"
        "&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max"
        "&windspeed_unit=kmh"
        "&timezone=auto";

    final res = await client.get(url);

    return WeatherFullModel.fromJson(res);
  }
}
