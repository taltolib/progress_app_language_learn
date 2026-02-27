import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/language_provider.dart';
import 'package:progress/core/providers/language_selection_provider.dart';
import 'package:progress/core/providers/navigation_provider.dart';
import 'package:progress/core/providers/selected_language_provider.dart';
import 'package:progress/core/providers/theme_provider.dart';
import 'package:progress/core/providers/translation_provider.dart';
import 'package:provider/provider.dart';

import 'core/providers/introduction_provider.dart';
import 'main/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('uz')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => IntroductionProvider()),
          ChangeNotifierProvider(create: (_) => LanguageSelectionProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => TranslationProvider()),
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) =>  SelectedLanguageProvider()),
          ChangeNotifierProvider(create: (_) =>  ThemeProvider()),
        ],
        child: const App(),
      ),
    ),
  );
}
