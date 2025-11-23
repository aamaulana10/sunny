// lib/feature/common/mascot_widget.dart
import 'package:flutter/material.dart';
import 'package:sunny/core/utils/helper/condition_helper.dart';

class MascotWidget extends StatefulWidget {
  final int code;
  const MascotWidget({super.key, required this.code});

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 0.96,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  String _mascotAsset(int code) {
    if (code == 0) return "asset/image/clearsky.png"; // sunglasses vibe
    if ([61, 63, 65, 80, 81, 82].contains(code)) {
      return "asset/image/showerrain.png"; // umbrella vibe
    }
    if ([1, 2, 3].contains(code)) {
      return "asset/image/brokenclouds.png"; // sleepy vibe
    }
    if ([95, 96, 99].contains(code)) return "asset/image/thunderstorm.png";
    return ConditionHelper.getIcon(code) ?? "asset/image/clearsky.png";
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Image.asset(_mascotAsset(widget.code), height: 200, width: 200),
    );
  }
}
