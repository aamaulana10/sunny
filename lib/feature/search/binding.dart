import 'package:get/get.dart';
import 'package:sunny/feature/search/controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchViewController());
  }
}