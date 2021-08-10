import 'package:intl/intl.dart';

class ConvertHelper {

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is int) {
      return double.parse(value.toString());
    }
    else {
      return value;
    }
  }

  static String milisToDay(int milis) {

    var dateTime = DateTime.fromMillisecondsSinceEpoch(milis * 1000);

    var day = DateFormat("EEEE").format(dateTime);

    print(day);

    return day;
  }

  static String milisToDate(int milis) {

    var dateTime = DateTime.fromMillisecondsSinceEpoch(milis * 1000);

    var date = DateFormat("dd MMMM yyyy").format(dateTime);

    print(date);

    return date;
  }

  static String milisToHour(int milis) {
    var fixedValue = DateTime.fromMillisecondsSinceEpoch(milis * 1000);

    var dateFormat = new DateFormat('HH.mm');

    var currentDate = dateFormat.format(fixedValue);

    return currentDate;
  }

  static String milToKmPerHour(double value) {
    if (value != null) {
      var fixedValue = value * 1.609;

      return fixedValue.toStringAsFixed(1);
    } else {
      return "0";
    }
  }

  static String mToKmPerHour(double value) {
    if (value != null) {
      var fixedValue = value * 3.6;

      return fixedValue.toStringAsFixed(1);
    } else {
      return "0";
    }
  }

  static String mToKm(int value) {
    if (value != null) {
      var fixedValue = value / 1000;

      return fixedValue.toStringAsFixed(0);
    } else {
      return "0";
    }
  }

  static String kelvinToCelcius(double temp) {
    if (temp != null) {
      var fixedvalue = temp - 273.15;

      return fixedvalue.toStringAsFixed(1);
    } else {
      return "0";
    }
  }
}