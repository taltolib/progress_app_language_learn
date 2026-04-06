abstract class LocaleKeys {
  // Auth & Language
  static const String authSelectLanguage = 'create.select_language';
  static const String authContinue = 'create.continue';
  static const String authUzbek = 'create.uzbek';
  static const String authRussian = 'create.russian';
  static const String authEnglish = 'create.english';

  // Introduction / Onboarding
  static const String discoverTitle = 'discover.title';
  static const String discoverSubtitle = 'discover.subtitle';
  static const String discoverBody = 'discover.body';

  static const String progressTitle = 'progress.title';
  static const String progressSubtitle = 'progress.subtitle';
  static const String progressBody = 'progress.body';

  static const String practiceTitle = 'practice.title';
  static const String practiceSubtitle = 'practice.subtitle';
  static const String practiceBody = 'practice.body';

  // Home Page
  static const String homeWelcome = 'home_welcome';
  static const String homeStartLesson = 'home_start_lesson';
  static const String homePage = 'home_page';
  static const String searchPage = 'search_page';
  static const String favoritePage = 'favorite_page';
  static const String transPage = 'trans_page';
  static const String profilePage = 'profile_page';

  // Settings & Profile
  static const String settings = 'settings';
  static const String premium = 'get_premium';
  static const String activateCode = 'activate_code';
  static const String theme = 'theme';
  static const String dark = 'dark';
  static const String darkTheme = 'dark_theme';
  static const String light = 'light';
  static const String lightTheme = 'light_theme';
  static const String appLanguage = 'app_language';
  static const String logout = 'logout';
  static const String deleteAccount = 'delete_account';
  static const String choiceLang = 'choice_lang';
  static const String writeWord = 'write_word';
  static const String choiceLSetting = 'choice_l_setting';
  static const String searchLang = 'search_lang';

  // Notifications
  static const String notificationBannerTitle = 'notification_banner_title';
  static const String notificationBannerSubtitle = 'notification_banner_subtitle';

  // Заголовки и сообщения уровней
  static const String levelLockedTitle = 'level_locked_title';
  static const String levelLockedMessage = 'level_locked_message';
  static const String levelMaxScoreTitle = 'level_max_score_title';
  static const String levelMaxScoreMessage = 'level_max_score_message';

  // Кнопки и общие слова
  static const String confirm = 'confirm';
  static const String ok = 'ok';
  static const String back = 'back';
  static const String goHome = 'go_home';
  static const String loading = 'loading';
  static const String addLanguage = 'add_language';

  // Статистика
  static const String errors = 'errors';
  static const String accuracy = 'accuracy';
  static const String time = 'time';
  static const String levelCompleted = 'level_completed';

  // Состояния
  static const String dataNotFound = 'data_not_found';
  static const String errorWithText = 'error_with_text';
  static const String allow = 'allow';
  static const String levelHeader = 'level_header';
  static const String levelTasks = 'level_tasks';

  // Похвалы (для ServiceProvider)
  static const String compliment1 = 'compliment_1';
  static const String compliment2 = 'compliment_2';
  static const String compliment3 = 'compliment_3';

  // Streak & Heart System
  static const String streakTitle = 'streak_title';
  static const String streakSubtitle1 = 'streak_subtitle_1';
  static const String streakSubtitle2 = 'streak_subtitle_2';
  static const String streakSubtitle3 = 'streak_subtitle_3';
  static const String streakSubtitle4 = 'streak_subtitle_4';
  static const String streakSubtitle5 = 'streak_subtitle_5';

  static const String streakBody1 = 'streak_body_1';
  static const String streakBody2 = 'streak_body_2';
  static const String streakBody3 = 'streak_body_3';
  static const String streakBody4 = 'streak_body_4';
  static const String streakBody5 = 'streak_body_5';

  static const String heartDialogTitle = 'heart_dialog_title';
  static const String heartDialogWait = 'heart_dialog_wait';
  static const String heartDialogInfo = 'heart_dialog_info';

  // Game answer words — ключ для перевода слов из уровней
  // Использование: LocaleKeys.word('еда').tr()  →  "food" / "ovqat" / "еда"
  static String word(String russianWord) => 'words.$russianWord';
}