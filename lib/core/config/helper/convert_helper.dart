import 'package:intl/intl.dart';

class ConvertHelper {
  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is int) {
      return double.parse(value.toString());
    } else {
      return value;
    }
  }

  static String milisToDay(int milis) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(milis * 1000);

    var day = DateFormat("EEEE", "id_ID").format(dateTime);

    return day;
  }

  static String milisToDate(int milis) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(milis * 1000);

    var date = DateFormat("dd MMMM yyyy", "id_ID").format(dateTime);

    return date;
  }

  static String milisToFullDate(int? milis) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch((milis ?? 0) * 1000);

    var date = DateFormat("EEEE, dd MMMM yyyy", "id_ID").format(dateTime);

    return date;
  }

  static String milisToHour(int milis) {
    var fixedValue = DateTime.fromMillisecondsSinceEpoch(milis * 1000);

    var dateFormat = new DateFormat('HH.mm');

    var currentDate = dateFormat.format(fixedValue);

    return currentDate;
  }

  static String formatHourIso(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return "${dt.hour.toString().padLeft(2, '0')}:00";
    } catch (_) {
      return "--:--";
    }
  }

  static String formatTimeIso(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return "--:--";
    }
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
