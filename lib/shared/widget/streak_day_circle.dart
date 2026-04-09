import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/domain/enums/streak_day_status.dart';

class StreakDayCircle extends StatelessWidget {
  final String dayName;
  final StreakDayStatus status;
  final bool isToday;

  const StreakDayCircle({
    super.key,
    required this.dayName,
    required this.status,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          dayName,
          style: TextStyle(
            color: isToday ? Colors.orange : Colors.grey,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        _buildIcon(context),
      ],
    );
  }

  Widget _buildIcon(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    switch (status) {
      case StreakDayStatus.completed:
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            const Icon(Icons.check, size: 30, color: Colors.white),
          ],
        );
      case StreakDayStatus.frozen:
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade300,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlue.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const Icon(Icons.ac_unit, size: 30, color: Colors.white),
          ],
        );
      case StreakDayStatus.pending:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: colors.backgroundWhiteOrDark, width: 1.5),
            color: colors.backgroundAcceptsWhiteOrDark,
            shape: BoxShape.circle,
          ),
        );
      case StreakDayStatus.failed:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red.shade200,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.white),
        );
    }
  }
}
