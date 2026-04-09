import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:progress/core/firebase/firebase_options.dart';
import 'package:progress/core/hive/app_prefs.dart';
import 'package:progress/core/providers/auth_provider.dart';
import 'package:progress/core/providers/cards_provider.dart';
import 'package:progress/core/providers/create_profile_provider.dart';
import 'package:progress/core/providers/game_provider.dart';
import 'package:progress/core/providers/introduction_provider.dart';
import 'package:progress/core/providers/language_selection_provider.dart';
import 'package:progress/core/providers/loading_level_provider.dart';
import 'package:progress/core/providers/login_provider.dart';
import 'package:progress/core/providers/navigation_provider.dart';
import 'package:progress/core/providers/search_provider.dart';
import 'package:progress/core/providers/selected_language_provider.dart';
import 'package:progress/core/providers/streak_provider.dart';
import 'package:progress/core/providers/task_image_provider.dart';
import 'package:progress/core/providers/theme_provider.dart';
import 'package:progress/core/providers/word_detail_provider.dart';
import 'package:progress/generated/task/task_generator.dart';
import 'package:provider/provider.dart';

import 'main/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('game_data');
  await AppPrefs.init();
  await TaskGenerator.loadLevels();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('uz')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => IntroductionProvider()),
          ChangeNotifierProvider(create: (_) => LanguageSelectionProvider()),
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) => SelectedLanguageProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => GameProvider()),
          ChangeNotifierProvider(create: (_) => LoadingLevelProvider()),
          ChangeNotifierProvider(create: (_) => TaskImageProvider()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CreateProfileProvider()),
          ChangeNotifierProvider(create: (_) => CardsProvider()),
          ChangeNotifierProvider(create: (_) => SearchProvider()),
          ChangeNotifierProvider(create: (_) => WordDetailProvider()),
          ChangeNotifierProvider(create: (_) => StreakProvider()..init()),
        ],
        child: const App(),
      ),
    ),
  );
}