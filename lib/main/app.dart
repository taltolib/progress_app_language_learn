import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/auth_provider.dart' as custom_auth;
import 'package:progress/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../core/navigation/go_router.dart';
import '../core/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // themeMode: ThemeMode.dark,
      themeMode: context.watch<ThemeProvider>().themeMode,
      routerConfig: buildRouter(context.read<custom_auth.AuthProvider>()),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
