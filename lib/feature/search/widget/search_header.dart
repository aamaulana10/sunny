import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/feature/search/controller.dart';

class SearchHeaderWidget extends StatelessWidget {
  const SearchHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchViewController>();

    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.colorWidget,
                    ),
                    child: TextFormField(
                      onChanged: (e) => controller.setInputLocation(e),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        if (controller.locationInput.value.isNotEmpty) {
                          controller.getCurrentWeather(
                            controller.locationInput.value,
                          );
                        }
                      },
                      style: TextStyle(
                        color: AppColors.textColorLight,
                        fontFamily: 'NunitoRegular',
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 22,
                        ),
                        labelText: "Cari Lokasi",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                          color: AppColors.textLabelDark,
                          fontSize: 12,
                          fontFamily: 'NunitoRegular',
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Suggested Cities
          Container(
            margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in [
                  "Jakarta",
                  "Bandung",
                  "Surabaya",
                  "Yogyakarta",
                ])
                  _chip(context, s, () => controller.getCurrentWeather(s)),
              ],
            ),
          ),

          // Recent Searches
          Obx(
            () => Container(
              margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in controller.recentSearches)
                    _chip(context, s, () => controller.getCurrentWeather(s)),
                ],
              ),
            ),
          ),

          // Current Location
          Container(
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              "Lokasi Saat ini",
              style: TextStyle(
                color: AppColors.textLabelDark,
                fontWeight: FontWeight.w700,
                fontFamily: 'NunitoBold',
              ),
            ),
          ),

          Obx(
            () => InkWell(
              onTap: () {
                if (controller.cityFromAddress.value.isNotEmpty) {
                  controller.getCurrentWeather(
                    controller.cityFromAddress.value,
                  );
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Text(
                  controller.address.value,
                  style: TextStyle(
                    color: AppColors.textLabelDark,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'NunitoRegular',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.colorWidget,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.textColorLight,
            fontFamily: 'NunitoRegular',
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
