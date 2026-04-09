import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/game_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/domain/models/level_model.dart';
import 'package:progress/domain/models/level_status.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/duolingo_button_painter.dart'
    show DuolingoButtonPainter;
import 'package:provider/provider.dart';

class LevelPushCustomButton extends StatelessWidget {
  final LevelModel level;
  final bool isActive;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback onTap;

  const LevelPushCustomButton({
    super.key,
    required this.level,
    required this.isActive,
    required this.isCompleted,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<AppThemeColors>()!;
    final game = context.watch<GameProvider>();

    final int score = game.levelResults[level.id] ?? 0;

    // 1. Получаем статус уровня через функцию из level_status.dart
    final status = getStatus(score, isLocked: isLocked);

    return GestureDetector(
      onTap: () {
        if (isLocked) {
          _showDialog(
              context,
              LocaleKeys.levelLockedTitle.tr(),
              LocaleKeys.levelLockedMessage.tr()
          );
        } else if (score == 100) {
          _showDialog(
              context,
              LocaleKeys.levelMaxScoreTitle.tr(),
              LocaleKeys.levelMaxScoreMessage.tr()
          );
        } else {
          onTap();
        }
      },
      child: CustomPaint(
        painter: DuolingoButtonPainter(
          topColor: status.getTopColor(context),
          baseColor: status.getBaseColor(context),
          borderColor: status.getBorderColor(context),
        ),
        child: SizedBox(
          width: 120,
          height: 120,
          child: Center(
            child: score == 100
                ? const Icon(Icons.star, color: Colors.white, size: 45)
                : Text(
              "${level.id}",
              style:  AppFonts.mulish.s32w700(color: isLocked
                  ? themeColors.borderBlack.withOpacity(0.4)
                  : Colors.white,),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.ok.tr(), style: const TextStyle(color: AppColors.green)),
          ),
        ],
      ),
    );
  }
}