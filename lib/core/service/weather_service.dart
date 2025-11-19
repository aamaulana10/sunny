import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sunny/core/config/network/api_config.dart';
import 'package:sunny/core/model/weather_forecast_model.dart';
import 'package:sunny/core/model/weather_model.dart';

class HomeService {

  /// service ini untuk apaa
  Future<WeatherMainModel> getCurrentWeatherByCity(String city) {
    
    var url = "${ApiConfig.baseUrl}weather?q=$city&appid=${ApiConfig.apiKey}";

    print(url);

      return http.get(Uri.parse(url))
          .then((response) {

        final data = json.decode(response.body) ;

        var weather = WeatherMainModel.fromJson(data);

        return weather;

      });

  }

  Future<WeatherForecastModel> getCurrentWeatherByLatLong(String latitude, String longitude) {

    var url = "${ApiConfig.baseUrl}onecall?&units=metric&exclude=minutely&appid=${ApiConfig.apiKey}&lat=$latitude&lon=$longitude&lang=en";

    print(url);

    return http.get(Uri.parse(url))
        .then((response) {

      final data = json.decode(response.body) ;

      var forecast = new WeatherForecastModel();

      forecast = WeatherForecastModel.fromJson(data);

      return forecast;

    });
  }

  // Future<RssFeed> getNewsFromRss() async{

  //     var response = await http.get(Uri.parse("https://www.antaranews.com/rss/warta-bumi.xml"));

  //     if(response.body.isNotEmpty) {

  //         return RssFeed.parse(response.body);

  //     }else {

  //       throw Exception("error parse rss");
  //     }
  // }

}