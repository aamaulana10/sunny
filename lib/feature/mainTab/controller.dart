import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/feature/home/page.dart';
import 'package:sunny/feature/search/view/search_view.dart';
import 'package:sunny/feature/weatherList/view/weather_list_view.dart';

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
        screen = HomeView();
        break;
      case 1:
        screen = const SearchView();
        break;
      case 2:
        screen = const WeatherListView();
        break;
      default:
        screen = HomeView();
    }

    _cachedScreens[index] = screen;
    return screen;
  }

  void switchTab(int index) {
    currentIndex.value = index;
  }
}
