class TempHelper {

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
}