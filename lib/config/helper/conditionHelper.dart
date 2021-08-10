import 'dart:collection';

import 'package:sunny/feature/home/model/weatherForecastModel.dart';

class ConditionHelper {

    static Map<String, String> getCondition(String condition) {

      print("condition " + condition);

      var data = {};

      switch (condition) {
        case "01d":

          data["description"] = "Langit Cerah";
          data["icon"] = "asset/image/clearsky.png";

          break;

        case "01n":

          data["description"] = "Langit Cerah";
          data["icon"] = "asset/image/clearsky.png";

          break;

        case "04d":

          data["description"] = "Agak Mendung";
          data["icon"] = "asset/image/brokenclouds.png";

          break;

        case "04n":

          data["description"] = "Agak Mendung";
          data["icon"] = "asset/image/brokenclouds.png";

          break;

        case "02d":

          data["description"] = "Sedikit Berawan";
          data["icon"] = "asset/image/fewclouds.png";

          break;

        case "02n":

          data["description"] = "Sedikit Berawan";
          data["icon"] = "asset/image/fewclouds.png";

          break;

        case "50d":

          data["description"] = "Berkabut";
          data["icon"] = "asset/image/mist.png";

          break;

        case "50n":

          data["description"] = "Berkabut";
          data["icon"] = "asset/image/mist.png";

          break;

        case "10d":

          data["description"] = "Hujan";
          data["icon"] = "asset/image/rain.png";

          break;

        case "10n":

          data["description"] = "Hujan";
          data["icon"] = "asset/image/rain.png";

          break;

        case "03d":

          data["description"] = "Berawan";
          data["icon"] = "asset/image/scatteredclouds.png";

          break;

        case "03n":

          data["description"] = "Berawan";
          data["icon"] = "asset/image/scatteredclouds.png";

          break;

        case "09d":

          data["description"] = "Hujan Deras";
          data["icon"] = "asset/image/showerrain.png";

          break;

        case "09n":

          data["description"] = "Hujan Deras";
          data["icon"] = "asset/image/showerrain.png";

          break;

        case "13d":

          data["description"] = "Salju";
          data["icon"] = "asset/image/snow.png";

          break;

        case "13n":

          data["description"] = "Salju";
          data["icon"] = "asset/image/snow.png";

          break;

        case "11d":

          data["description"] = "Hujan petir";
          data["icon"] = "asset/image/thunderstorm.png";

          break;

        case "11n":

          data["description"] = "Hujan petir";
          data["icon"] = "asset/image/thunderstorm.png";

          break;
      }

      return HashMap.from(data);
    }

    static String getDescription(Current weatherForecastCurrent) {

      return getCondition(weatherForecastCurrent.weather[0].icon)["description"];
    }

    static String getDescriptionHourly(Hourly weatherForecastHourly) {

      return getCondition(weatherForecastHourly.weather[0].icon)["description"];
    }

    static String getDescriptionDaily(Daily weatherForecastDaily) {

      return getCondition(weatherForecastDaily.weather[0].icon)["description"];
    }

    static String getIcon(Current weatherForecastCurrent) {

      return getCondition(weatherForecastCurrent.weather[0].icon)["icon"];
    }

    static String getIconHourly(Hourly weatherForecastHourly) {

      return getCondition(weatherForecastHourly.weather[0].icon)["icon"];
    }

    static String getIconDaily(Daily weatherForecastDaily) {

      return getCondition(weatherForecastDaily.weather[0].icon)["icon"];
    }
}