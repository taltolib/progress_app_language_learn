import 'package:flutter/material.dart';

class HoleClipper extends CustomClipper<Path> {
  final double radius;

  HoleClipper(this.radius);

  @override
  Path getClip(Size size) {
    final fullScreen = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final hole = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: radius,
        ),
      );

    return Path.combine(
      PathOperation.difference,
      fullScreen,
      hole,
    );
  }

  @override
  bool shouldReclip(covariant HoleClipper oldClipper) {
    return oldClipper.radius != radius;
  }
}
