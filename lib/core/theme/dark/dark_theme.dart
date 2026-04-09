import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import '../colors/app_colors.dart';

class DarkTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.backgroundDark,

    colorScheme: const ColorScheme.dark(
      surface: AppColors.backgroundAcceptsDark,
      onSurface: AppColors.textWhite,
      error: AppColors.heartRed,
    ),

    dividerColor: AppColors.borderGrey,

    extensions: const [
      AppThemeColors(
        backgroundWhiteOrDark: AppColors.backgroundDark,
        backgroundAcceptsWhiteOrDark: AppColors.backgroundAcceptsDark,
        whiteForLight: AppColors.textWhite,
        dividerWhite: AppColors.borderGrey,
        textGrey: AppColors.textGrey,
        textBlack: AppColors.textWhite,
        borderBlack: AppColors.borderGrey,
        text: AppColors.textWhite,
        shadow: AppColors.borderGrey,

      ),
    ],
  );
}