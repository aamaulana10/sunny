import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sunny/config/network/apiConfig.dart';
import 'package:sunny/feature/home/model/weatherForecastModel.dart';
import 'package:sunny/feature/home/model/weatherModel.dart';

class HomeService {

  /// service ini untuk apaa
  Future<WeatherMainModel> getCurrentWeatherByCity(String city) {
    
    var url = ApiConfig.baseUrl + "weather?q=" + city + "&appid=" + ApiConfig.apiKey;

    print(url);

      return http.get(url)
          .then((response) {

        final data = json.decode(response.body) ;

        var weather = new WeatherMainModel();

        weather = WeatherMainModel.fromJson(data);

        return weather;

      });

  }

  Future<WeatherForecastModel> getCurrentWeatherByLatLong(String latitude, String longitude) {

    var url = ApiConfig.baseUrl + "onecall?&units=metric&exclude=minutely&appid="
        + ApiConfig.apiKey + "&lat=" + latitude + "&lon=" + longitude + "&lang=en";

    print(url);

    return http.get(url)
        .then((response) {

      final data = json.decode(response.body) ;

      print(data);

      var forecast = new WeatherForecastModel();

      forecast = WeatherForecastModel.fromJson(data);

      return forecast;

    });
  }

}