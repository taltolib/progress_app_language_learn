import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';

class DuolingoButtonPainter extends CustomPainter {
  final bool isActive;
  final bool isCompleted;
  final Color themeColor;
  final Brightness brightness;

  const DuolingoButtonPainter({
    required this.isActive,
    required this.isCompleted,
    required this.themeColor,
    required this.brightness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 8);

    Color topColor;
    Color baseColor;

    if (isCompleted) {
      topColor = AppColors.goldColors;
      baseColor = AppColors.darkGold;
    }

    else if (isActive) {
      topColor = AppColors.brandGreen;
      baseColor = AppColors.brandGreenPressed;
    }

    else {
      topColor = themeColor;

      if (brightness == Brightness.light) {
        baseColor = AppColors.borderLight;
      } else {
        baseColor = AppColors.borderDark;
      }
    }

    final base = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2.0, size.height - 56),
        width: 102,
        height: 70,
      ),
      const Radius.circular(100),
    );

    final basePaint = Paint()..color = baseColor;
    canvas.drawRRect(base, basePaint);

    final circleRect =
    Rect.fromCenter(center: center, width: 100, height: 80);

    final circlePaint = Paint()..color = topColor;
    canvas.drawOval(circleRect, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}