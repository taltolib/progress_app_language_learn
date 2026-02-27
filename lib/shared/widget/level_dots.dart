
import 'package:flutter/material.dart';

class SnakeDots extends StatelessWidget {
  final double startT;
  final double endT;
  final double Function(double) snakeX;

  const SnakeDots({
    super.key,
    required this.startT,
    required this.endT,
    required this.snakeX,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: List.generate(4, (i) {
          final t = startT + (endT - startT) * ((i + 1) / 5);

          return Align(
            alignment: Alignment(snakeX(t), 0),
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3E4A53),
              ),
            ),
          );
        }),
      ),
    );
  }
}