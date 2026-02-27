import 'package:flutter/material.dart';
import 'package:progress/core/providers/navigation_provider.dart';
import 'package:progress/features/home/home_page.dart';
import 'package:progress/features/search/search_page.dart';
import 'package:progress/features/settings/settings_page.dart';
import 'package:progress/features/task/task_page.dart';
import 'package:progress/shared/widget/custom_home_app_bar.dart';
import 'package:progress/shared/widget/glass_navigation_bar.dart';
import 'package:progress/shared/widget/notification_banner.dart';
import 'package:progress/shared/widget/page_config.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool showNotificationBanner = true;

  late final List<PageConfig> pages;

  @override
  void initState() {
    super.initState();

    pages = const [
      PageConfig(
        page: HomePage(),
        showNotification: true,
      ),
      PageConfig(
        page: SearchPage(),
      ),
      PageConfig(
        page: TaskPage(),
        showAppBar: false,
      ),
      PageConfig(
        page: SettingsPage(),
        appBarIcon: Icons.edit,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();
    final currentPage = pages[navigationProvider.currentIndex];

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: currentPage.showAppBar
          ? PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: currentPage.showNotification && showNotificationBanner
            ? NotificationBanner(
          onAllow: () {
            setState(() {
              showNotificationBanner = false;
            });
          },
        )
            : CustomHomeAppBar(
          icon: currentPage.appBarIcon,
        ),
      )
          : null,

      body: IndexedStack(
        index: navigationProvider.currentIndex,
        children: pages.map((e) => e.page).toList(),
      ),

      bottomNavigationBar: GlassNavigationBar(
        currentIndex: navigationProvider.currentIndex,
        onTap: (index) {
          context.read<NavigationProvider>().setIndex(index);
        },
      ),
    );
  }
}