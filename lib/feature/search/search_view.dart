import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/feature/search/controller.dart';
import 'package:sunny/feature/search/widget/forecast_list.dart';
import 'package:sunny/feature/search/widget/search_header.dart';
import 'package:sunny/feature/search/widget/weather_column_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  void _gotoDetailDaily(BuildContext context, int index) {
    final controller = Get.find<SearchViewController>();
    final weather = controller.weather.value;

    if (weather?.daily != null) {
      // TODO: Navigate to detail page
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DetailForecastDaily(
      //       date: weather.daily!.time[index],
      //       tempMax: weather.daily!.temperatureMax[index],
      //       tempMin: weather.daily!.temperatureMin[index],
      //       weatherCode: weather.daily!.weathercode[index],
      //       address: controller.address.value,
      //     ),
      //   ),
      // );

      debugPrint("Navigate to detail for index: $index");
    }
  }

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
                  onTapItem: (index) => _gotoDetailDaily(context, index),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
