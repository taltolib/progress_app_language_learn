import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import '../../core/theme/colors/app_colors.dart';

class GlassNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<GlassNavigationBar> createState() => _GlassNavigationBarState();
}

class _GlassNavigationBarState extends State<GlassNavigationBar> {
  final List<IconData> icons = [
    Icons.home,
    Icons.search,
    Icons.favorite,
    Icons.person,
  ];

  final List<String> labels = [
    LocaleKeys.homePage,
    LocaleKeys.searchPage,
    LocaleKeys.favoritePage,
    LocaleKeys.profilePage,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / icons.length;

          return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Theme.of(context).extension<AppThemeColors>()!.backgroundWhiteOrDark.withOpacity(0.40),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Theme.of(context).extension<AppThemeColors>()!.backgroundAcceptsWhiteOrDark,
                  ),
                  boxShadow: isDark
                      ? []
                      : [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      left: widget.currentIndex * itemWidth,
                      top: 8,
                      bottom: 8,
                      width: itemWidth,
                      child: Center(
                        child: Container(
                          width: itemWidth * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            // ignore: deprecated_member_use
                            color: AppColors.green.withOpacity(
                              isDark ? 0.20 : 0.10,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Row(
                      children: List.generate(
                        icons.length,
                            (index) => Expanded(
                          child: _navItem(index, isDark),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _navItem(int index, bool isDark) {
    final bool isActive = index == widget.currentIndex;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedScale(
        scale: isActive ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icons[index],
              size: 22,
              color: isActive
                  ? AppColors.green :Theme.of(context).extension<AppThemeColors>()!.textGrey,
            ),
            const SizedBox(height: 4),
            Text(
              labels[index].tr(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.green
                    : Theme.of(context).extension<AppThemeColors>()!.textGrey,

              ),
            ),
          ],
        ),
      ),
    );
  }
}