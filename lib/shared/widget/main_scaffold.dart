import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/game_provider.dart';
import 'package:progress/core/providers/navigation_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/features/home/home_page.dart';
import 'package:progress/features/search/search_page.dart';
import 'package:progress/features/settings/settings_page.dart';
import 'package:progress/features/task/game_page.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/app_bar_game_page.dart';
import 'package:progress/shared/widget/custom_home_app_bar.dart';
import 'package:progress/shared/widget/glass_navigation_bar.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  List<Widget> _getPages() {
    return const [
      HomePage(),
      SearchPage(),
      GamePage(),
      SettingsPage(),
    ];
  }

  void _showHeartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final colors = Theme.of(context).extension<AppThemeColors>()!;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<GameProvider>(
            builder: (context, provider, child) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.backgroundWhiteOrDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.backgroundAcceptsWhiteOrDark, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            LocaleKeys.heartDialogTitle.tr(),
                            textAlign: TextAlign.center,
                            style: AppFonts.mulish.s18w600(color: Colors.redAccent.shade100),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text("❤️", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      provider.refillCountdown,
                      style: AppFonts.mulish.s18w700(color: colors.text),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      LocaleKeys.heartDialogWait.tr(),
                      style: AppFonts.mulish.s14w400(color:colors.text),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.heartDialogInfo.tr(),
                      style: AppFonts.mulish.s14w600(color: AppColors.gold),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget? _getAppBar(int index, BuildContext context) {
    final p = context.watch<GameProvider>();
    switch (index) {
      case 0: // HomePage
        return const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: CustomHomeAppBar(icon: Icons.notifications_none),
        );
      case 1: // SearchPage
        return null;
        // return const PreferredSize(
        //   preferredSize: Size.fromHeight(100),
        //   child: CustomHomeAppBar(icon: Icons.notifications_none),
        // );
      case 2: // GamePage
        return PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: AppBarGamePage(
            tryS: p.playerProgress.hearts,
            daysCompleted: p.playerProgress.streakCount,
            onTapForLanguage: () {},
            onTapForDay: () {},
            onTapForLive: () => _showHeartDialog(context),
          ),
        );
      case 3: // SettingsPage
        return const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: CustomHomeAppBar(icon: Icons.notifications_none),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();
    final currentIndex = navigationProvider.currentIndex;

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _getAppBar(currentIndex, context),
      body: IndexedStack(
        index: currentIndex,
        children: _getPages(),
      ),
      bottomNavigationBar: GlassNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          context.read<NavigationProvider>().setIndex(index);
        },
      ),
    );
  }
}
