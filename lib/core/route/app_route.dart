import 'package:get/get.dart';
import 'package:sunny/feature/home/binding.dart';
import 'package:sunny/feature/mainTab/binding.dart';
import 'package:sunny/feature/mainTab/main_tab.dart';
import 'package:sunny/feature/search/binding.dart';
import 'package:sunny/feature/setting/bindings.dart';
import 'package:sunny/feature/weather_detail/page.dart';

class AppRoutes {
  static const mainTab = '/main-tab';
  static const weatherDetail = '/weather-detail';

  static final pages = [
    GetPage(
      name: '/',
      page: () => const MainTab(),
      bindings: [
        MainTabBinding(),
        HomeBinding(),
        SearchBinding(),
        SettingBinding(),
      ],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: weatherDetail,
      page: () => const WeatherDetails(),
      transition: Transition.fadeIn,
    ),
  ];
}
