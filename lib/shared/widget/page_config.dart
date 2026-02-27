import 'package:flutter/material.dart';

class PageConfig {
  final Widget page;
  final bool showAppBar;
  final IconData appBarIcon;
  final bool showNotification;

  const PageConfig({
    required this.page,
    this.showAppBar = true,
    this.appBarIcon = Icons.notifications_none,
    this.showNotification = false,
  });
}