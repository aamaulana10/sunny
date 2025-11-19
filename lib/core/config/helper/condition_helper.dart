import 'dart:collection';

import 'package:sunny/core/model/weather_forecast_model.dart';

class ConditionHelper {
  static Map<String, String> getCondition(String? condition) {
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

  static Map<String, String> getImageNotifFromCondition(String condition) {
    var data = {};

    switch (condition) {
      case "01d":
        data["description"] = "Langit Cerah";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1bpL0SlKd3GSFeNs_EF0vIXm3uee9aErD";

        break;

      case "01n":
        data["description"] = "Langit Cerah";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1bpL0SlKd3GSFeNs_EF0vIXm3uee9aErD";

        break;

      case "04d":
        data["description"] = "Agak Mendung";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1YUb9jd8BmfS5nH11EOVAa3Dg9qJJerDE";

        break;

      case "04n":
        data["description"] = "Agak Mendung";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1YUb9jd8BmfS5nH11EOVAa3Dg9qJJerDE";

        break;

      case "02d":
        data["description"] = "Sedikit Berawan";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1KKKr-AdX-dUSliIRxcnuNfmuxlQxRc2L";

        break;

      case "02n":
        data["description"] = "Sedikit Berawan";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1KKKr-AdX-dUSliIRxcnuNfmuxlQxRc2L";

        break;

      case "50d":
        data["description"] = "Berkabut";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=165O9JqKllnJIZ16d3GlrtQwJ5F5Wk10F";

        break;

      case "50n":
        data["description"] = "Berkabut";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=165O9JqKllnJIZ16d3GlrtQwJ5F5Wk10F";

        break;

      case "10d":
        data["description"] = "Hujan";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1bma4Rp9LfL789aecmLIwAHcB0XQSwHBA";

        break;

      case "10n":
        data["description"] = "Hujan";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1bma4Rp9LfL789aecmLIwAHcB0XQSwHBA";

        break;

      case "03d":
        data["description"] = "Berawan";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1mJfzfrlozKHlpw93c4fGcAjbw_aeOEzr";

        break;

      case "03n":
        data["description"] = "Berawan";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1mJfzfrlozKHlpw93c4fGcAjbw_aeOEzr";

        break;

      case "09d":
        data["description"] = "Hujan Deras";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1kX5rfmq29StziHd-rALICEZLoWfTg49o";

        break;

      case "09n":
        data["description"] = "Hujan Deras";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1kX5rfmq29StziHd-rALICEZLoWfTg49o";

        break;

      case "13d":
        data["description"] = "Salju";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1O3N99prSC8L1HXriPmQfOByXtbdW1J8A";

        break;

      case "13n":
        data["description"] = "Salju";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1O3N99prSC8L1HXriPmQfOByXtbdW1J8A";

        break;

      case "11d":
        data["description"] = "Hujan petir";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1X854NvnnwkLzSyPJIhwhvbXzvX6kRQAv";

        break;

      case "11n":
        data["description"] = "Hujan petir";
        data["icon"] =
            "https://drive.google.com/uc?export=view&id=1X854NvnnwkLzSyPJIhwhvbXzvX6kRQAv";

        break;
    }

    return HashMap.from(data);
  }

  static String? getDescription(Current weatherForecastCurrent) {
    return getCondition(weatherForecastCurrent.weather?[0].icon)["description"];
  }

  static String? getDescriptionHourly(Hourly weatherForecastHourly) {
    return getCondition(weatherForecastHourly.weather?[0].icon)["description"];
  }

  static String? getDescriptionDaily(Daily weatherForecastDaily) {
    return getCondition(weatherForecastDaily.weather?[0].icon)["description"];
  }

  static String? getIcon(Current weatherForecastCurrent) {
    return getCondition(weatherForecastCurrent.weather?[0].icon)["icon"];
  }

  static String? getIconHourly(Hourly weatherForecastHourly) {
    return getCondition(weatherForecastHourly.weather?[0].icon)["icon"];
  }

  static String? getIconDaily(Daily weatherForecastDaily) {
    return getCondition(weatherForecastDaily.weather?[0].icon)["icon"];
  }
}
