import 'package:flutter/material.dart';

class CurvedPathPainter extends CustomPainter {
  final int levelCount;

  CurvedPathPainter(this.levelCount);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final path = Path();

    double spacing = size.height / levelCount;

    path.moveTo(size.width / 2, 0);

    for (int i = 1; i < levelCount; i++) {
      double y = spacing * i;
      double xOffset = i.isEven ? -80 : 80;

      path.quadraticBezierTo(
        size.width / 2 + xOffset,
        y - spacing / 2,
        size.width / 2,
        y,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}