import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorConfig {

  static Future<Color> getPrimaryColor() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    var darkMode = preferences.getBool("isDarkMode");

    print(darkMode);

    if(darkMode == true) {

      return Color(0xFF0A214E);
    } else {

      return Colors.white;
    }

  }

  static Color navigationBottomColor = Color(0xFF0A214E);
  static Color darkBackgroundColor = Color(0xFF0A214E);
  static Color lightBackgroundColor = Colors.white;
  static Color textColorDark = Colors.black;
  static Color textColorLight = Colors.white;
}