// lib/feature/share/share_card_view.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:sunny/core/config/color/app_colors.dart';
import 'package:sunny/core/config/helper/condition_helper.dart';
import 'package:sunny/feature/home/controller.dart';

class ShareCardView extends StatelessWidget {
  ShareCardView({super.key});
  final _key = GlobalKey();

  Future<String> _savePng() async {
    final boundary =
        _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/sunny_share_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    final w = c.weather.value;
    final city = c.address.value;
    final temp = w?.current.temperature ?? 0;
    final code = w?.current.weatherCode ?? 0;
    final mood = ConditionHelper.getMoodMessage(code);
    final icon = ConditionHelper.getIcon(code) ?? 'asset/image/clearsky.png';

    return Scaffold(
      backgroundColor: AppColors.darkBackgroundColor,
      appBar: AppBar(
        title: const Text('Share Card'),
        backgroundColor: AppColors.navigationBottomColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          RepaintBoundary(
            key: _key,
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.pinkAccent.withOpacity(.3),
                    Colors.blueAccent.withOpacity(.3),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'NunitoBold',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(icon, height: 80, width: 80),
                  const SizedBox(height: 8),
                  Text(
                    "${temp.toStringAsFixed(1)}°C",
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontFamily: 'NunitoBold',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mood,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final path = await _savePng();
              Get.snackbar(
                "Saved",
                "Card saved: $path",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text("Save Card"),
          ),
        ],
      ),
    );
  }
}
