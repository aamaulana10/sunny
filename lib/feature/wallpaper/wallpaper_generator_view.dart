// lib/feature/wallpaper/wallpaper_generator_view.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sunny/core/shared/theme/color/app_colors.dart';



class WallpaperGeneratorView extends StatelessWidget {
  WallpaperGeneratorView({super.key});
  final _key = GlobalKey();

  Future<String> _saveWallpaper() async {
    final boundary =
        _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3);
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


    return Scaffold(
      backgroundColor: AppColors.darkBackgroundColor,
      appBar: AppBar(
        title: const Text('Wallpaper Generator'),
        backgroundColor: AppColors.navigationBottomColor,
      ),
      body: RepaintBoundary(
        key: _key,
        child: Center(
          child: Text(
            "Sunny",
            style: TextStyle(
              color: Colors.white.withOpacity(.9),
              fontSize: 48,
              fontFamily: 'NunitoBold',
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final path = await _saveWallpaper();
          Get.snackbar(
            "Saved",
            "Wallpaper saved: $path",
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
