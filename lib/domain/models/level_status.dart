import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';

enum LevelStatus {
  locked,
  orange,
  green,
  gold
}

LevelStatus getStatus(int score, {bool isLocked = false}) {
  if (isLocked) return LevelStatus.locked;
  if (score == 100) return LevelStatus.gold;
  if (score >= 75) return LevelStatus.orange;
  if (score  == 0) return LevelStatus.green;
  return LevelStatus.green;
}

extension LevelStatusExtension on LevelStatus {

  Color getTopColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<AppThemeColors>()!;

    switch (this) {
      case LevelStatus.locked:
        return themeColors.backgroundWhiteOrDark;
      case LevelStatus.gold:
        return AppColors.gold;
      case LevelStatus.orange:
        return AppColors.orange;
      case LevelStatus.green:
        return AppColors.green;
    }
  }

  // Возвращает нижний цвет (тень/база)
  Color getBaseColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<AppThemeColors>()!;

    switch (this) {
      case LevelStatus.locked:
        return themeColors.backgroundAcceptsWhiteOrDark;
      case LevelStatus.gold:
        return  AppColors.darkGold;
      case LevelStatus.orange:
        return AppColors.darkOrange;
      case LevelStatus.green:
        return AppColors.blackGreen;
    }
  }

  Color getBorderColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<AppThemeColors>()!;

    switch (this) {
      case LevelStatus.locked:
        return themeColors.backgroundAcceptsWhiteOrDark;
      case LevelStatus.gold:
        return  AppColors.darkGold;
      case LevelStatus.orange:
        return AppColors.darkOrange;
      case LevelStatus.green:
        return AppColors.blackGreen;
    }
  }
}
