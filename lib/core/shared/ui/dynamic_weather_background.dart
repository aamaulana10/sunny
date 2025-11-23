// lib/feature/common/dynamic_weather_background.dart
import 'package:flutter/material.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';

class DynamicWeatherBackground extends StatefulWidget {
  final int code;
  const DynamicWeatherBackground({super.key, required this.code});

  @override
  State<DynamicWeatherBackground> createState() =>
      _DynamicWeatherBackgroundState();
}

class _DynamicWeatherBackgroundState extends State<DynamicWeatherBackground> {
  LinearGradient _gradient(int code) {
    if (code == 0) {
      return LinearGradient(
        colors: [Colors.orange.withOpacity(.3), Colors.amber.withOpacity(.2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if ([1, 2].contains(code)) {
      return LinearGradient(
        colors: [
          Colors.blue.shade200.withOpacity(.25),
          Colors.purple.shade200.withOpacity(.2),
        ],
      );
    }
    if (code == 3) {
      return LinearGradient(
        colors: [Colors.blueGrey.withOpacity(.25), Colors.black12],
      );
    }
    if ([61, 63, 65, 80, 81, 82].contains(code)) {
      return LinearGradient(
        colors: [
          Colors.indigo.withOpacity(.25),
          Colors.blueAccent.withOpacity(.2),
        ],
      );
    }
    if ([95, 96, 99].contains(code)) {
      return LinearGradient(
        colors: [Colors.deepPurple.withOpacity(.3), Colors.black26],
      );
    }
    return LinearGradient(
      colors: [AppColors.darkBackgroundColor, AppColors.darkBackgroundColor],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(gradient: _gradient(widget.code)),
      child: const SizedBox.expand(),
    );
  }
}
