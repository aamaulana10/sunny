import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/feature/home/controller.dart';
import 'package:sunny/feature/home/widget/home_header.dart';
import 'package:sunny/feature/home/widget/home_today.dart';
import 'package:sunny/feature/home/widget/home_weather.dart';

class HomePage extends StatelessWidget {
  final controller = Get.find<HomeController>();

  HomePage({super.key});

  // void gotoDetail(Hourly weatherHourly) {
  //   print("detail view");

  //   /// pong ini biar inkwell nya ga terlalu cepet , jadi animasi ke teken dulu ,
  //   /// baru eksekusi pindah halaman
  //   Future.delayed(Duration(milliseconds: 500)).then((value) {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder:
  //             (context) => DetailForecastHourly(
  //               weatherHourly: weatherHourly,
  //               address: controller.address.value,
  //             ),
  //       ),
  //     );
  //   });
  // }

  // void gotoDetailNews(String url) {
  //   Future.delayed(Duration(milliseconds: 500)).then((value) {
  //     Navigator.of(
  //       context,
  //     ).push(MaterialPageRoute(builder: (ctx) => DetailNewsView(url: url)));
  //   });
  // }

  void gotoListNews() {
    // Navigator.of(
    //   context,
    // ).push(MaterialPageRoute(builder: (ctx) => ListNewsView()));
  }

  void gotoFullReport() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => MainTabbar(selectedIndex: 2)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackgroundColor,
      body: RefreshIndicator(
        color: AppColors.mainColor,
        onRefresh: () async { await controller.getCurrentLocation(); },
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: HomeHeaderWidget(controller: controller)),
            SliverToBoxAdapter(child: HomeWeatherWidget(controller: controller)),
            SliverToBoxAdapter(child: HomeTodayWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
