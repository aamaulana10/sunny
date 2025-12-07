// lib/feature/share/share_card_view.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/core/utils/helper/condition_helper.dart';
import 'package:sunny/feature/home/controller.dart';

class ShareCardView extends StatefulWidget {
  const ShareCardView({super.key});
  @override
  State<ShareCardView> createState() => _ShareCardViewState();
}

class _ShareCardViewState extends State<ShareCardView> {
  final _key = GlobalKey();
  int _styleIndex = 0; // 0 simple, 1 elegant, 2 fun
  int _gradientIndex = 0; // 0 pastel violet, 1 sunset, 2 mint

  final List<List<Color>> _gradients = const [
    [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
    [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
    [Color(0xFFB3FFAB), Color(0xFF12FFF7)],
  ];

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

    final displayedCity = _styleIndex == 1 ? city.toUpperCase() : city;
    final moodText = _styleIndex == 2 ? "$mood 😊" : mood;

    return Scaffold(
      backgroundColor: AppColors.darkBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Bagikan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.darkBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Simple'),
                selected: _styleIndex == 0,
                onSelected: (v) => setState(() => _styleIndex = 0),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Elegant'),
                selected: _styleIndex == 1,
                onSelected: (v) => setState(() => _styleIndex = 1),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Fun'),
                selected: _styleIndex == 2,
                onSelected: (v) => setState(() => _styleIndex = 2),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Pastel'),
                selected: _gradientIndex == 0,
                onSelected: (v) => setState(() => _gradientIndex = 0),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Sunset'),
                selected: _gradientIndex == 1,
                onSelected: (v) => setState(() => _gradientIndex = 1),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Mint'),
                selected: _gradientIndex == 2,
                onSelected: (v) => setState(() => _gradientIndex = 2),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RepaintBoundary(
            key: _key,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _gradients[_gradientIndex],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    displayedCity,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'NunitoBold',
                      letterSpacing: _styleIndex == 1 ? 1.2 : 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(icon, height: 84, width: 84),
                  const SizedBox(height: 8),
                  Text(
                    "${temp.toStringAsFixed(1)}°C",
                    style: const TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      fontFamily: 'NunitoBold',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    moodText,
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
              final caption =
                  "$city • ${temp.toStringAsFixed(1)}°C — $mood #SunnyApp";
              await Share.shareXFiles([XFile(path)], text: caption);
            },
            child: const Text("Share"),
          ),
        ],
      ),
    );
  }
}
