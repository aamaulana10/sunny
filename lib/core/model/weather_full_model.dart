class WeatherFullModel {
  final CurrentWeather current;
  final HourlyWeather hourly;
  final DailyWeather daily;

  WeatherFullModel({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherFullModel.fromJson(Map<String, dynamic> json) {
    return WeatherFullModel(
      current: CurrentWeather.fromJson(json['current_weather']),
      hourly: HourlyWeather.fromJson(json['hourly']),
      daily: DailyWeather.fromJson(json['daily']),
    );
  }
}

class CurrentWeather {
  final double temperature;
  final double windSpeed;
  final int weatherCode;

  CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature'] ?? 0).toDouble(),
      windSpeed: (json['windspeed'] ?? 0).toDouble(),
      weatherCode: json['weathercode'] ?? 0,
    );
  }
}

class HourlyWeather {
  final List<String> time;
  final List<double> temperature;
  final List<int> humidity;
  final List<int> weatherCode;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.weatherCode,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: List<String>.from(json['time'] ?? []),
      temperature: List<double>.from(
        (json['temperature_2m'] ?? []).map((e) => e.toDouble()),
      ),
      humidity: List<int>.from(json['relative_humidity_2m'] ?? []),
      weatherCode: List<int>.from(json['weathercode'] ?? []),
    );
  }
}

class DailyWeather {
  final List<String> time;
  final List<int> weatherCode;
  final List<double> temperatureMax;
  final List<double> temperatureMin;

  DailyWeather({
    required this.time,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      time: List<String>.from(json['time'] ?? []),
      weatherCode: List<int>.from(json['weathercode'] ?? []),
      temperatureMax: List<double>.from(
        (json['temperature_2m_max'] ?? []).map((e) => e.toDouble()),
      ),
      temperatureMin: List<double>.from(
        (json['temperature_2m_min'] ?? []).map((e) => e.toDouble()),
      ),
    );
  }
}
