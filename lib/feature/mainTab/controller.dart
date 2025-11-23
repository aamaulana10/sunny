import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/feature/home/page.dart';
import 'package:sunny/feature/search/search_view.dart';
import 'package:sunny/feature/weatherList/view/weather_list_view.dart';
import 'package:sunny/feature/setting/page.dart';

class MainTabController extends GetxController {
  final currentIndex = 0.obs;

  final Map<int, Widget> _cachedScreens = {};

  Widget getScreen(int index) {
    if (_cachedScreens[index] != null) {
      return _cachedScreens[index]!;
    }

    late Widget screen;

    switch (index) {
      case 0:
        screen = HomePage();
        break;
      case 1:
        screen = const SearchPage();
        break;
      case 2:
        screen = const WeatherListPage();
        break;
      case 3:
        screen = SettingPage();
        break;
      default:
        screen = HomePage();
    }

    _cachedScreens[index] = screen;
    return screen;
  }

  void switchTab(int index) {
    currentIndex.value = index;
  }
}
