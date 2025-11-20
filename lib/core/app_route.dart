import 'package:get/get.dart';
import 'package:sunny/feature/home/binding.dart';
import 'package:sunny/feature/mainTab/binding.dart';
import 'package:sunny/feature/mainTab/main_tab.dart';

class AppRoutes {
  static const mainTab = '/main-tab';

  static final pages = [
    GetPage(
      name: '/',
      page: () => const MainTab(),
      bindings: [MainTabBinding(), HomeBinding()],
      transition: Transition.fadeIn,
    ),
  ];
}
