import 'package:flutter/material.dart';

class DuolingoButtonPainter extends CustomPainter {
  final Color topColor;
  final Color baseColor;
  final Color? borderColor;

  const DuolingoButtonPainter({
    required this.topColor,
    required this.baseColor,
    this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {

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


    final Paint borderPaint = Paint()
      // ignore: deprecated_member_use
      ..color = borderColor ?? Colors.white.withOpacity(0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    final Offset center = Offset(size.width / 2, size.height / 2);


    final Rect bottomRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + (depth / 2)),
      width: buttonWidth,
      height: buttonHeight,
    );
    canvas.drawOval(bottomRect, basePaint);

    final Rect topRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - (depth / 2)),
      width: buttonWidth,
      height: buttonHeight,
    );
    

    canvas.drawOval(topRect, topPaint);
    

    canvas.drawOval(topRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant DuolingoButtonPainter oldDelegate) {
    return oldDelegate.topColor != topColor || 
           oldDelegate.baseColor != baseColor ||
           oldDelegate.borderColor != borderColor;
  }
}
