import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';

class BallCounter extends StatefulWidget {
  final int score;

  const BallCounter({super.key, required this.score});

  @override
  State<BallCounter> createState() => _BallCounterState();
}

class _BallCounterState extends State<BallCounter> {
  final int maxScore = 100;

  @override
  Widget build(BuildContext context) {
      double progress = (widget.score / maxScore).clamp(0.0, 1.0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
       const SizedBox(width:  20,),
        Expanded(child: _progressBall(progress),),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _progressBall(double progress) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final progressWidth = maxWidth * progress;
        return Stack(
          children: [
            Container(
              height: 15,
              width: maxWidth,
              decoration: BoxDecoration(
                color: AppColors.borderBlack,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            Container(
              height: 15,
              width: progressWidth,
              decoration: BoxDecoration(
                color: AppColors.blackGreen,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
             Positioned(
              left: 5,
              top: 5,
              child: Container(
                height: 4,
                width: progressWidth > 10 ? progressWidth - 10 : 0,
                decoration: BoxDecoration(
                  color:  Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
