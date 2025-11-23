import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static Future<Color> getPrimaryColor() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    var darkMode = preferences.getBool("isDarkMode");

    if (darkMode == true) {
      return Color(0xFF0A214E);
    } else {
      return Colors.white;
    }
  }

  static Color navigationBottomColor = Color(0xFF0A214E);
  static Color darkBackgroundColor = Color(0XFF121212);
  static Color lightBackgroundColor = Colors.white;
  static Color textColorDark = Colors.black;
  static Color textColorLight = Colors.white;
  static Color textLabelColor = Color(0XFFA0A0A0);
  static Color textLabelDark = Color(0XFFE1E1E1);
  static Color colorGrey = Colors.grey;
  static Color mainColor = Color(0XFFBB86FC);
  static Color colorWidget = Color(0XFF1E1E1E);
}
