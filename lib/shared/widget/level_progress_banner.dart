import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/providers/game_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/task/task_generator.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/day_counter_coin.dart';
import 'package:provider/provider.dart';

class LevelProgressBanner extends StatefulWidget {
  const LevelProgressBanner({super.key});

  @override
  State<LevelProgressBanner> createState() => _LevelProgressBannerState();
}

class _LevelProgressBannerState extends State<LevelProgressBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _btnController;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _btnController.dispose();
    super.dispose();
  }



  int _maxScoreForLevel(int levelId) {
    try {
      final lvl = TaskGenerator.allLevels.firstWhere(
        (l) => l.id == levelId,
        orElse: () => TaskGenerator.allLevels.first,
      );
      return lvl.tasks.length * 5;
    } catch (_) {
      return 100;
    }
  }




  void _handleTap(BuildContext context, GameProvider gp) async {
    final needed = gp.nextLevel;
    if (needed > 1) {
      final prev = needed - 1;
      final prevScore = gp.levelResults[prev] ?? 0;
      final prevMax = _maxScoreForLevel(prev);
      final prevAccuracy = prevMax > 0 ? prevScore / prevMax : 0.0;

      if (prevAccuracy < 0.75) {
        _showLockedDialog(context, prev);
        return;
      }
    }

    setState(() => _pressed = true);
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => _pressed = false);

    if (context.mounted) {
      context.push('/level/${gp.nextLevel}');
    }
  }

  void _showLockedDialog(BuildContext context, int prevLevel) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '🔒 Уровень заблокирован',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Сначала пройди $prevLevel-й уровень, чтобы открыть следующий!',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/level/$prevLevel');
            },
            child: Text(
              'Играть $prevLevel уровень',
              style: const TextStyle(color: AppColors.green),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final currentLevel = gp.nextLevel;
    final nextLevel = currentLevel + 1;


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      decoration: BoxDecoration(
        color: colors.backgroundAcceptsWhiteOrDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            // ignore: deprecated_member_use
            color: Colors.grey.shade400.withOpacity(0.08), width: 1
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.upToLore.tr(),
            style: AppFonts.mulish.s16w700(color: AppColors.orange),
          ),
          const SizedBox(height: 4),
          Text(
            LocaleKeys.goToLevelUp.tr(args: ["${gp.nextLevel}"]),
            style: AppFonts.mulish.s14w400(color: colors.text),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(LocaleKeys.levelHeader.tr(args: [""]), style: AppFonts.mulish.s14w700(color: colors.text),),
                  const SizedBox(width: 8),
                  DayCounterCoin(value: currentLevel, size: 30, isActive: true,),
                ],
              ),
             Row(
               children: [
                 Text(LocaleKeys.levelHeader.tr(args: [""]) , style: AppFonts.mulish.s14w700(color: colors.text),),
                 const SizedBox(width: 8),
                 DayCounterCoin(value: nextLevel, size: 30, isActive: false,),
               ],
             )
            ],
          ),
          const SizedBox(height: 20),
          _PlayButton(
            pressed: _pressed,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) async {
              setState(() => _pressed = false);
              await Future.delayed(const Duration(milliseconds: 80));
              if (context.mounted) _handleTap(context, gp);
            },
            onTapCancel: () => setState(() => _pressed = false),
          ),
        ],
      ),
    );
  }
}


class _PlayButton extends StatelessWidget {
  final bool pressed;
  final GestureTapDownCallback onTapDown;
  final GestureTapUpCallback onTapUp;
  final VoidCallback onTapCancel;

  const _PlayButton({
    required this.pressed,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    const shadowColor = Color(0xFFD4700A);
    const height = 50.0;
    const shadowHeight = 6.0;
    const radius = 16.0;

    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: SizedBox(
        height: height + shadowHeight,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: shadowColor,
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              bottom: pressed ? 0 : shadowHeight,
              left: 0,
              right: 0,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFB800),
                      Color(0xFFFF7A00),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: shadowColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.goTo.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
