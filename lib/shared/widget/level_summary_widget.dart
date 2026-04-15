 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/game_provider.dart';
import 'package:progress/core/providers/loading_level_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/push_button.dart';
import 'package:provider/provider.dart';

class LevelSummaryWidget extends StatefulWidget {
  final VoidCallback onHomeTap;

  const LevelSummaryWidget({super.key, required this.onHomeTap});

  @override
  State<LevelSummaryWidget> createState() => _LevelSummaryWidgetState();
}

class _LevelSummaryWidgetState extends State<LevelSummaryWidget> {

  late final GameProvider game;
  late final LoadingLevelProvider service;

  @override
  void initState() {
    super.initState();
    game = context.read<GameProvider>();
    service = context.read<LoadingLevelProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final compliment = service.randomCompliment;
    final image = service.randomImage;
    final colors =Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      backgroundColor: colors.backgroundWhiteOrDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              const Spacer(),
              image,
              const SizedBox(height: 40),
              Text(
                compliment.tr(),
                style: AppFonts.mulish.s28w700(
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statBox(
                    context,
                    LocaleKeys.errors.tr(),
                    game.errorCount.toString(),
                    Icons.error_outline,
                   AppColors.heartRed,
                  ),
                  _statBox(
                    context,
                      LocaleKeys.accuracy.tr(),
                    "${game.accuracyPercentage.toInt()}%",
                    Icons.star_outline,
                    Colors.orange,
                  ),
                  _statBox(
                    context,
                     LocaleKeys.time.tr(),
                    game.formattedTime,
                    Icons.timer_outlined,
                    Colors.blue,
                  ),
                ],
              ),
              const Spacer(),
              PushButton(
                language: LocaleKeys.goHome.tr(),
                flagAsset: Container(),
                onTap: widget.onHomeTap,
                isSelected: false,
                height: 70,
                borderRadius: 15,
                color: AppColors.green,
                colorShadow: AppColors.blackGreen,
                colorText: Colors.white,
                fontSize: 18,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final colors =Theme.of(context).extension<AppThemeColors>()!;
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.backgroundWhiteOrDark,
        borderRadius: BorderRadius.circular(15),
        // ignore: deprecated_member_use
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppFonts.mulish.s18w700(color: colors.text),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: AppFonts.mulish.s12w400(color: colors.text),
          ),
        ],
      ),
    );
  }
}
