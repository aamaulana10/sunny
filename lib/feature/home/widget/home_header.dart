import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sunny/core/config/color/app_colors.dart';
import 'package:sunny/core/config/helper/condition_helper.dart';
import 'package:sunny/feature/home/controller.dart';

class HomeHeaderWidget extends StatelessWidget {
  final HomeController controller;
  const HomeHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var dateFormat = DateFormat('EEEE, dd MMMM yyyy', "id_ID");

      var currentDate = dateFormat.format(DateTime.now());

      return Container(
        margin: EdgeInsets.only(left: 8, right: 8, top: 30),
        padding: EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                controller.address.value,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textLabelDark,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NunitoSemiBold',
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Text(
                currentDate.toString(),
                style: TextStyle(
                  color: AppColors.textLabelDark,
                  fontSize: 12,
                  fontFamily: 'NunitoRegular',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.colorWidget,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "🔥 Streak: ",
                        style: TextStyle(
                          color: AppColors.textLabelDark,
                          fontFamily: 'NunitoSemiBold',
                        ),
                      ),
                      Text(
                        controller.streak.value.toString(),
                        style: TextStyle(
                          color: AppColors.textColorLight,
                          fontFamily: 'NunitoBold',
                        ),
                      ),
                      Text(
                        " hari • ${ConditionHelper.getBadge(controller.streak.value)}",
                        style: TextStyle(
                          color: AppColors.textLabelDark,
                          fontFamily: 'NunitoSemiBold',
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          controller.isForecast.isTrue
                              ? AppColors.mainColor
                              : AppColors.colorWidget,
                    ),
                    child: MaterialButton(
                      minWidth: 100,
                      onPressed: () {
                        controller.isForecast.value = true;
                      },
                      child: Text(
                        "Cuaca",
                        style: TextStyle(
                          color: AppColors.textColorLight,
                          fontFamily: 'NunitoSemiBold',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          controller.isForecast.isFalse
                              ? AppColors.mainColor
                              : AppColors.colorWidget,
                    ),
                    child: MaterialButton(
                      minWidth: 100,
                      onPressed: () {
                        controller.isForecast.value = false;
                      },
                      child: Text(
                        "Kualitas Udara",
                        style: TextStyle(
                          color: AppColors.textColorLight,
                          fontFamily: 'NunitoSemiBold',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
