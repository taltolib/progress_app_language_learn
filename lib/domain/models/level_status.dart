import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';

enum LevelStatus {
  locked,
  blue,
  green,
  gold
}

LevelStatus getStatus(int score, {bool isLocked = false}) {
  if (isLocked) return LevelStatus.locked;
  if (score == 100) return LevelStatus.gold;
  if (score >= 75) return LevelStatus.green;
  if (score > 0 && score < 75) return LevelStatus.blue;
  return LevelStatus.green; // По умолчанию зеленый для открытого уровня с 0 баллов
}

extension LevelStatusExtension on LevelStatus {
  // Возвращает верхний цвет (основной)
  Color getTopColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<AppThemeColors>()!;

    switch (this) {
      case LevelStatus.locked:
        return themeColors.backgroundWhiteOrDark;
      case LevelStatus.gold:
        return AppColors.gold;
      case LevelStatus.blue:
        return AppColors.blue;
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
      case LevelStatus.blue:
        return AppColors.blueDark;
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
      case LevelStatus.blue:
        return AppColors.blueDark;
      case LevelStatus.green:
        return AppColors.blackGreen;
    }
  }
}
