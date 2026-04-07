import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/domain/enums/streak_day_status.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/shared/widget/streak_day_circle.dart';

class StreakCard extends StatelessWidget {
  final int streakDays;
  final String title;
  final String subTitle;
  final String body;
  final List<StreakDayStatus> weekProgress;

  const StreakCard({
    super.key,
    required this.streakDays,
    required this.title,
    required this.subTitle,
    required this.weekProgress,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final daysNames = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      decoration: BoxDecoration(
        color:  colors.backgroundAcceptsWhiteOrDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400.withOpacity(0.08), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          Text(
            subTitle,
            style: AppFonts.mulish.s16w700(color:colors.text),
          ),
          const SizedBox(height: 4),
           Text(
            body,
            style: AppFonts.mulish.s14w400(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              int currentWeekday = DateTime.now().weekday;
              int todayIndex = currentWeekday == 7 ? 0 : currentWeekday;
              return StreakDayCircle(
                dayName: daysNames[index],
                status: weekProgress[index],
                isToday: index == todayIndex,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flash_on, color: Colors.orange, size: 24),
          const SizedBox(width: 8),
          Text(
            '$streakDays',
            style: AppFonts.mulish.s22w600(color: Colors.orange),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: AppFonts.mulish.s14w600(color: Colors.orange),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
