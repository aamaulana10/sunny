import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/core/route/app_route.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/feature/search/controller.dart';
import 'package:sunny/feature/search/widget/forecast_list.dart';
import 'package:sunny/feature/search/widget/search_header.dart';
import 'package:sunny/feature/search/widget/weather_column_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(SearchViewController());

    return Scaffold(
      backgroundColor: AppColors.darkBackgroundColor,
      body: Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            // Header with search bar
            const SearchHeaderWidget(),

            // Content Area
            Expanded(
              child: Obx(() {
                // Show empty state if not searching
                if (!controller.isSearch.value) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // const EmptyStateWidget(),
                        const SizedBox(height: 20),
                        // Weather Column Cards (tampil kalau ada data)
                        const WeatherColumnWidget(),
                      ],
                    ),
                  );
                }

                // Show forecast list if searching
                return NextForecastList(
                  onTapItem: (index) {
                    Get.toNamed(
                      AppRoutes.weatherDetail,
                      arguments: controller.weather.value,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
