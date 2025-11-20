import 'package:get/get.dart';
import 'package:sunny/feature/mainTab/controller.dart';

class MainTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainTabController());
  }
}