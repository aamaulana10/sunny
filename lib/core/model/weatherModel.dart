import 'package:sunny/core/config/helper/convertHelper.dart';

class WeatherMainModel {
  final Coord coord;
  final List<Weather> weather;
  final String base;
  final Main main;
  final int visibility;
  final Wind wind;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int timezone;
  final int id;
  final String name;

  WeatherMainModel({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
  });

  WeatherMainModel.fromJson(Map<String, dynamic> json)
      : coord = json['coord'] != null 
          ? Coord.fromJson(json['coord']) 
          : Coord(lon: 0.0, lat: 0.0),
        weather = json['weather'] != null 
          ? List<Weather>.from(json['weather'].map((v) => Weather.fromJson(v)))
          : [],
        base = json['base'] ?? '',
        main = json['main'] != null 
          ? Main.fromJson(json['main'])
          : Main(temp: 0, feelsLike: 0, tempMin: 0, tempMax: 0, pressure: 0, humidity: 0),
        visibility = json['visibility'] ?? 0,
        wind = json['wind'] != null 
          ? Wind.fromJson(json['wind'])
          : Wind(speed: 0, deg: 0),
        clouds = json['clouds'] != null 
          ? Clouds.fromJson(json['clouds'])
          : Clouds(all: 0),
        dt = json['dt'] ?? 0,
        sys = json['sys'] != null 
          ? Sys.fromJson(json['sys'])
          : Sys(type: 0, id: 0, country: '', sunrise: 0, sunset: 0),
        timezone = json['timezone'] ?? 0,
        id = json['id'] ?? 0,
        name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
    'coord': coord.toJson(),
    'weather': weather.map((v) => v.toJson()).toList(),
    'base': base,
    'main': main.toJson(),
    'visibility': visibility,
    'wind': wind.toJson(),
    'clouds': clouds.toJson(),
    'dt': dt,
    'sys': sys.toJson(),
    'timezone': timezone,
    'id': id,
    'name': name,
  };
}

class Coord {
  final double lon;
  final double lat;

  Coord({
    required this.lon,
    required this.lat,
  });

  Coord.fromJson(Map<String, dynamic> json)
      : lon = (json['lon'] ?? 0).toDouble(),
        lat = (json['lat'] ?? 0).toDouble();

  Map<String, dynamic> toJson() => {
    'lon': lon,
    'lat': lat,
  };
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  Weather.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        main = json['main'] ?? '',
        description = json['description'] ?? '',
        icon = json['icon'] ?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'main': main,
    'description': description,
    'icon': icon,
  };
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  Main.fromJson(Map<String, dynamic> json)
      : temp = ConvertHelper.checkDouble(json['temp']) ?? 0,
        feelsLike = ConvertHelper.checkDouble(json['feels_like']) ?? 0,
        tempMin = ConvertHelper.checkDouble(json['temp_min']) ?? 0,
        tempMax = ConvertHelper.checkDouble(json['temp_max']) ?? 0,
        pressure = json['pressure'] ?? 0,
        humidity = json['humidity'] ?? 0;

  Map<String, dynamic> toJson() => {
    'temp': temp,
    'feels_like': feelsLike,
    'temp_min': tempMin,
    'temp_max': tempMax,
    'pressure': pressure,
    'humidity': humidity,
  };
}

class Wind {
  final double speed;
  final int deg;

  Wind({
    required this.speed,
    required this.deg,
  });

  Wind.fromJson(Map<String, dynamic> json)
      : speed = ConvertHelper.checkDouble(json['speed']) ?? 0,
        deg = json['deg'] ?? 0;

  Map<String, dynamic> toJson() => {
    'speed': speed,
    'deg': deg,
  };
}

class Clouds {
  final int all;

  Clouds({
    required this.all,
  });

  Clouds.fromJson(Map<String, dynamic> json)
      : all = json['all'] ?? 0;

  Map<String, dynamic> toJson() => {
    'all': all,
  };
}

class Sys {
  final int type;
  final int id;
  final String country;
  final int sunrise;
  final int sunset;

  Sys({
    required this.type,
    required this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  Sys.fromJson(Map<String, dynamic> json)
      : type = json['type'] ?? 0,
        id = json['id'] ?? 0,
        country = json['country'] ?? '',
        sunrise = json['sunrise'] ?? 0,
        sunset = json['sunset'] ?? 0;

  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'country': country,
    'sunrise': sunrise,
    'sunset': sunset,
  };
}
