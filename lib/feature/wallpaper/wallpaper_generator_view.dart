// lib/feature/wallpaper/wallpaper_generator_view.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';
import 'package:sunny/core/utils/helper/condition_helper.dart';
import 'package:sunny/feature/home/controller.dart';

class WallpaperGeneratorView extends StatefulWidget {
  const WallpaperGeneratorView({super.key});
  @override
  State<WallpaperGeneratorView> createState() => _WallpaperGeneratorViewState();
}

class _WallpaperGeneratorViewState extends State<WallpaperGeneratorView> {
  final _key = GlobalKey();
  int _styleIndex = 0;
  int _gradientIndex = 0;
  bool _watermark = true;
  double _pixelRatio = 3;

  final List<List<Color>> _gradients = const [
    [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
    [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
    [Color(0xFFB3FFAB), Color(0xFF12FFF7)],
  ];

  Future<String> _saveWallpaper() async {
    final boundary =
        _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: _pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/sunny_wallpaper_${DateTime.now().millisecondsSinceEpoch}.png',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Wallpaper",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.darkBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Minimal'),
                  selected: _styleIndex == 0,
                  onSelected: (_) => setState(() => _styleIndex = 0),
                  selectedColor: AppColors.mainColor,
                  backgroundColor: AppColors.colorWidget,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                ChoiceChip(
                  label: const Text('Poster'),
                  selected: _styleIndex == 1,
                  onSelected: (_) => setState(() => _styleIndex = 1),
                  selectedColor: AppColors.mainColor,
                  backgroundColor: AppColors.colorWidget,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                ChoiceChip(
                  label: const Text('Fun'),
                  selected: _styleIndex == 2,
                  onSelected: (_) => setState(() => _styleIndex = 2),
                  selectedColor: AppColors.mainColor,
                  backgroundColor: AppColors.colorWidget,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Pastel'),
                  selected: _gradientIndex == 0,
                  onSelected: (_) => setState(() => _gradientIndex = 0),
                  selectedColor: AppColors.mainColor,
                  backgroundColor: AppColors.colorWidget,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                ChoiceChip(
                  label: const Text('Sunset'),
                  selected: _gradientIndex == 1,
                  onSelected: (_) => setState(() => _gradientIndex = 1),
                  selectedColor: AppColors.mainColor,
                  backgroundColor: AppColors.colorWidget,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                ChoiceChip(
                  label: const Text('Mint'),
                  selected: _gradientIndex == 2,
                  onSelected: (_) => setState(() => _gradientIndex = 2),
                  selectedColor: AppColors.mainColor,
                  backgroundColor: AppColors.colorWidget,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Std'),
                  selected: _pixelRatio == 2,
                  onSelected: (_) => setState(() => _pixelRatio = 2),
                  selectedColor: AppColors.mainColor,
                  backgroundColor: AppColors.colorWidget,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                ChoiceChip(
                  label: const Text('HD'),
                  selected: _pixelRatio == 3,
                  onSelected: (_) => setState(() => _pixelRatio = 3),
                  selectedColor: AppColors.mainColor,
                  backgroundColor: AppColors.colorWidget,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                ChoiceChip(
                  label: const Text('4K'),
                  selected: _pixelRatio == 4,
                  onSelected: (_) => setState(() => _pixelRatio = 4),
                  selectedColor: AppColors.mainColor,
                  backgroundColor: AppColors.colorWidget,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    const Text(
                      'Watermark',
                      style: TextStyle(color: Colors.white),
                    ),
                    Switch(
                      value: _watermark,
                      onChanged: (v) => setState(() => _watermark = v),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            RepaintBoundary(
              key: _key,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _gradients[_gradientIndex],
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: _buildContent(city, temp, icon, mood),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final path = await _saveWallpaper();
                Get.snackbar(
                  'Disimpan',
                  'Wallpaper saved: $path',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.colorWidget,
                  colorText: AppColors.textColorLight,
                  margin: const EdgeInsets.all(12),
                  borderRadius: 12,
                  icon: const Icon(
                    Icons.download_done,
                    color: Colors.lightBlueAccent,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String city, double temp, String icon, String mood) {
    final titleStyle = TextStyle(
      fontSize: _styleIndex == 1 ? 28 : 22,
      color: Colors.white,
      fontFamily: 'NunitoBold',
      letterSpacing: _styleIndex == 1 ? 1.2 : 0,
    );
    final tempStyle = const TextStyle(
      fontSize: 72,
      color: Colors.white,
      fontFamily: 'NunitoBold',
    );
    final moodStyle = const TextStyle(fontSize: 16, color: Colors.white);

    switch (_styleIndex) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(city.toUpperCase(), style: titleStyle),
            const SizedBox(height: 12),
            Image.asset(icon, height: 110, width: 110),
            const SizedBox(height: 8),
            Text('${temp.toStringAsFixed(1)}°C', style: tempStyle),
            const SizedBox(height: 8),
            Text(mood, style: moodStyle),
            const SizedBox(height: 16),
            if (_watermark)
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Sunny',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontFamily: 'NunitoBold',
                  ),
                ),
              ),
          ],
        );
      case 2:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icon, height: 96, width: 96),
                const SizedBox(width: 12),
                Text('${temp.toStringAsFixed(1)}°C', style: tempStyle),
              ],
            ),
            const SizedBox(height: 10),
            Text('$mood 😊', style: moodStyle),
            const SizedBox(height: 8),
            Text(city, style: titleStyle),
            const SizedBox(height: 12),
            if (_watermark)
              Text(
                '#SunnyApp',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontFamily: 'NunitoSemiBold',
                ),
              ),
          ],
        );
      default:
        return Column(
          children: [
            Text(city, style: titleStyle),
            const SizedBox(height: 10),
            Text('${temp.toStringAsFixed(1)}°C', style: tempStyle),
            const SizedBox(height: 8),
            Image.asset(icon, height: 96, width: 96),
            const SizedBox(height: 8),
            Text(mood, style: moodStyle),
            const SizedBox(height: 12),
            if (_watermark)
              Text(
                'Sunny',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontFamily: 'NunitoBold',
                ),
              ),
          ],
        );
    }
  }
}
