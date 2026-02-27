import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/domain/models/task_level_model.dart';
import 'package:progress/shared/widget/duolingo_button_painter.dart'
    show DuolingoButtonPainter;

class TaskButton extends StatelessWidget {
  final TaskLevelModel level;
  final bool isActive;
  final VoidCallback onTap;

  const TaskButton({
    super.key,
    required this.level,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color buttonColor;

    if (level.isCompleted) {
      buttonColor = AppColors.goldColors;
    } else if (isActive) {
      buttonColor = AppColors.brandGreen;
    } else {
      buttonColor = theme.colorScheme.surface;
    }

    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DuolingoButtonPainter(
          isActive: isActive,
          isCompleted: level.isCompleted,
          themeColor: Theme
              .of(context)
              .colorScheme
              .surface,
          brightness: Theme
              .of(context)
              .brightness,
        ),
        child: SizedBox(
          width: 120,
          height: 120,
          child: Center(
            child: Icon(
              Icons.star,
              size: 36,
              color: level.isCompleted ? Colors.white : isActive ? AppColors.brandOnGreen : AppColors.borderLight,
            ),
          ),
        ),
      ),
    );
  }
}
