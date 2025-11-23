import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/feature/mainTab/controller.dart';

class MainTab extends StatelessWidget {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainTabController>();

    return Obx(() {
      return Scaffold(
        body: controller.getScreen(controller.currentIndex.value),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            // borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: BottomNavigationBar(
              backgroundColor: AppColors.darkBackgroundColor,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.currentIndex.value,
              onTap: controller.switchTab,
              selectedItemColor: AppColors.mainColor,
              unselectedItemColor: AppColors.textColorLight,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined),
                  activeIcon: Icon(Icons.search),
                  label: 'Cari Lokasi',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.wb_sunny_outlined),
                  activeIcon: Icon(Icons.wb_sunny_sharp),
                  label: 'Cuaca',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Pengaturan',
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
