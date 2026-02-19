import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/providers/introduction_provider.dart';
import 'main/app.dart';

void main() {
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('uz'),
      ],
      path: 'assets/language',
      fallbackLocale: const Locale('ru'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => IntroductionProvider(),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}
