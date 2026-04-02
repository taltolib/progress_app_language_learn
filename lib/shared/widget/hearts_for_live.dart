import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';

class HeartsForLive extends StatelessWidget {
  final int tryS;
  final double size;
  const HeartsForLive({super.key, required this.tryS, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.favorite,
          color: AppColors.heartRed,
          size: size,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Material(
            color: Colors.transparent,
            child: Text(
              tryS.toString(),
              style: TextStyle(
                color: AppColors.heartRed,
                fontSize: size * 0.6,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
