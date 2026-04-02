import 'package:flutter/material.dart';

class PageConfig {
  final Widget page;
  final PreferredSizeWidget? appBar; // Теперь храним конкретный AppBar

  const PageConfig({
    required this.page,
    this.appBar,
  });
}
