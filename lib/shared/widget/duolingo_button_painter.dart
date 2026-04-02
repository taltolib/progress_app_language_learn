import 'package:flutter/material.dart';

class DuolingoButtonPainter extends CustomPainter {
  final Color topColor;
  final Color baseColor;
  final Color? borderColor; // Опциональный цвет бортика

  const DuolingoButtonPainter({
    required this.topColor,
    required this.baseColor,
    this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Настройка пропорций для эффекта "лежачей" кнопки
    const double depth = 10.0; 
    const double perspectiveRatio = 0.85; 
    
    final double buttonWidth = size.width * 0.85;
    final double buttonHeight = buttonWidth * perspectiveRatio;

    final Paint basePaint = Paint()
      ..color = baseColor
      ..isAntiAlias = true;

    final Paint topPaint = Paint()
      ..color = topColor
      ..isAntiAlias = true;

    // Настройка кисти для бортика
    final Paint borderPaint = Paint()
      ..color = borderColor ?? Colors.white.withOpacity(0.20) // По умолчанию полупрозрачный белый
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    // Центрируем
    final Offset center = Offset(size.width / 2, size.height / 2);

    // 2. Рисуем нижнюю часть (Тень/База)
    final Rect bottomRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + (depth / 2)),
      width: buttonWidth,
      height: buttonHeight,
    );
    canvas.drawOval(bottomRect, basePaint);

    // 3. Рисуем верхнюю часть (Сама кнопка)
    final Rect topRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - (depth / 2)),
      width: buttonWidth,
      height: buttonHeight,
    );
    
    // Сначала заливка
    canvas.drawOval(topRect, topPaint);
    
    // Затем рисуем бортик поверх заливки
    canvas.drawOval(topRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant DuolingoButtonPainter oldDelegate) {
    return oldDelegate.topColor != topColor || 
           oldDelegate.baseColor != baseColor ||
           oldDelegate.borderColor != borderColor;
  }
}
