import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:sunny/core/utils/helper/convert_helper.dart';
import 'package:sunny/feature/weather/model/weather_model.dart';

class WeatherDetails extends StatelessWidget {
  const WeatherDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherModel weather = Get.arguments as WeatherModel;

    final hourly = weather.hourly;
    final daily = weather.daily;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Weather Details',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _DetailCard(
              icon: Icons.thermostat,
              label: 'Feels Like',
              value:
                  '${hourly.apparentTemperature.isNotEmpty ? hourly.apparentTemperature[0].toInt() : 0}°',
              index: 0,
            ),
            _DetailCard(
              icon: Icons.water_drop,
              label: 'Precipitation',
              value:
                  '${hourly.precipitationProbability.isNotEmpty ? hourly.precipitationProbability[0] : 0}%',
              index: 1,
            ),
            _DetailCard(
              icon: Icons.wb_sunny,
              label: 'UV Index',
              value:
                  '${hourly.uvIndex.isNotEmpty ? hourly.uvIndex[0].toInt() : 0}',
              index: 2,
            ),
            _DetailCard(
              icon: Icons.wb_twilight,
              label: 'Sunrise',
              value:
                  daily.sunrise.isNotEmpty
                      ? ConvertHelper.formatTimeIso(daily.sunrise[0])
                      : '--:--',
              index: 3,
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int index;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate(delay: (index * 80).ms)
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }
}
