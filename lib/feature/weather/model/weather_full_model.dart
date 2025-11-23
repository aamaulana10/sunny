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

  Map<String, dynamic> toJson() => {
        'current_weather': current.toJson(),
        'hourly': hourly.toJson(),
        'daily': daily.toJson(),
      };
}

class CurrentWeather {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final int windDirection;

  CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.windDirection,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature'] ?? 0).toDouble(),
      windSpeed: (json['windspeed'] ?? 0).toDouble(),
      weatherCode: json['weathercode'] ?? 0,
      windDirection: json['winddirection'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'windspeed': windSpeed,
        'weathercode': weatherCode,
        'winddirection': windDirection,
      };
}

class HourlyWeather {
  final List<String> time;
  final List<double> temperature;
  final List<double> apparentTemperature;
  final List<int> humidity;
  final List<int> weatherCode;
  final List<int> precipitationProbability;
  final List<double> precipitation;
  final List<double> uvIndex;
  final List<double> windspeed;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.weatherCode,
    required this.precipitationProbability,
    required this.precipitation,
    required this.uvIndex,
    required this.windspeed,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: List<String>.from(json['time'] ?? []),
      temperature: List<double>.from(
        (json['temperature_2m'] ?? []).map((e) => e.toDouble()),
      ),
      apparentTemperature: List<double>.from(
        (json['apparent_temperature'] ?? []).map((e) => e.toDouble()),
      ),
      humidity: List<int>.from(json['relative_humidity_2m'] ?? []),
      weatherCode: List<int>.from(json['weathercode'] ?? []),
      precipitationProbability:
          List<int>.from(json['precipitation_probability'] ?? []),
      precipitation: List<double>.from(
        (json['precipitation'] ?? []).map((e) => e.toDouble()),
      ),
      uvIndex: List<double>.from(
        (json['uv_index'] ?? []).map((e) => e.toDouble()),
      ),
      windspeed: List<double>.from(
        (json['windspeed_10m'] ?? []).map((e) => e.toDouble()),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'temperature_2m': temperature,
        'apparent_temperature': apparentTemperature,
        'relative_humidity_2m': humidity,
        'weathercode': weatherCode,
        'precipitation_probability': precipitationProbability,
        'precipitation': precipitation,
        'uv_index': uvIndex,
        'windspeed_10m': windspeed,
      };
}

class DailyWeather {
  final List<String> time;
  final List<int> weatherCode;
  final List<double> temperatureMax;
  final List<double> temperatureMin;
  final List<String> sunrise;
  final List<String> sunset;
  final List<double> uvIndexMax;

  DailyWeather({
    required this.time,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.sunrise,
    required this.sunset,
    required this.uvIndexMax,
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
      sunrise: List<String>.from(json['sunrise'] ?? []),
      sunset: List<String>.from(json['sunset'] ?? []),
      uvIndexMax: List<double>.from(
        (json['uv_index_max'] ?? []).map((e) => e.toDouble()),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'weathercode': weatherCode,
        'temperature_2m_max': temperatureMax,
        'temperature_2m_min': temperatureMin,
        'sunrise': sunrise,
        'sunset': sunset,
        'uv_index_max': uvIndexMax,
      };
}
