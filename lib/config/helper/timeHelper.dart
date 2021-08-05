import 'package:intl/intl.dart';

class TimeHelper {

  static String milisToDay(int milis) {

    var dateTime = DateTime.fromMillisecondsSinceEpoch(milis * 1000);

    var day = DateFormat("EEEE").format(dateTime);

    print(day);

    return day;
  }

  static String milisToDate(int milis) {

    var dateTime = DateTime.fromMillisecondsSinceEpoch(milis * 1000);

    var date = DateFormat("MMM, dd").format(dateTime);

    print(date);

    return date;
  }
}