import 'package:get/get.dart';
import 'package:sunny/feature/setting/controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
