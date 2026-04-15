import 'package:flutter/material.dart';

class DayCounterCoin extends StatelessWidget {
  final int value;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool isActive;
  final double borderThickness;

  const DayCounterCoin({
    super.key,
    required this.value,
    this.size = 80,
    this.activeColor = const Color(0xFFFFA726),
    this.inactiveColor = const Color(0xFFB0BEC5),
    this.isActive = true,
    this.borderThickness = 4,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = isActive ? activeColor : inactiveColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: isActive
              ? [
            // ignore: deprecated_member_use
            baseColor.withOpacity(0.9),
            baseColor,
            // ignore: deprecated_member_use
            baseColor.withOpacity(0.7),
          ]
              : [
            // ignore: deprecated_member_use
            baseColor.withOpacity(0.6),
            baseColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 6),
            blurRadius: 8,
          )
        ],
        border: Border.all(
          color: isActive
              ? activeColor
              : inactiveColor,
          width: borderThickness,
        ),
      ),
      child: Center(
        child: Text(
          "$value",
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}