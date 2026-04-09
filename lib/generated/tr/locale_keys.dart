abstract class LocaleKeys {
  // Auth & Language
  static const String authSelectLanguage = 'auth.select_language';
  static const String authContinue = 'auth.continue';
  static const String authUzbek = 'auth.uzbek';
  static const String authRussian = 'auth.russian';
  static const String authEnglish = 'auth.english';

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
  static const String getPremium = 'get_premium';
  static const String activateCode = 'activate_code';
  static const String settings = 'settings';
  static const String theme = 'theme';
  static const String dark = 'dark';
  static const String darkTheme = 'dark_theme';
  static const String light = 'light';
  static const String lightTheme = 'light_theme';
  static const String appLanguage = 'app_language';
  static const String logout = 'logout';
  static const String homePage = 'home_page';
  static const String searchPage = 'search_page';
  static const String favoritePage = 'favorite_page';
  static const String transPage = 'trans_page';
  static const String profilePage = 'profile_page';

  // Account
  static const String deleteAccount = 'delete_account';
  static const String titleForDeleteAccount = 'title_for_delete_account';
  static const String bodyForDeleteAccount = 'body_for_delete_account';

  // Selection
  static const String choiceLang = 'choice_lang';
  static const String searchLang = 'search_lang';
  static const String writeWord = 'write_word';
  static const String choiceLSetting = 'choice_l_setting';

  // Notifications
  static const String notificationBannerTitle = 'notification_banner_title';
  static const String notificationBannerSubtitle = 'notification_banner_subtitle';

  // Levels
  static const String levelLockedTitle = 'level_locked_title';
  static const String levelLockedMessage = 'level_locked_message';
  static const String levelMaxScoreTitle = 'level_max_score_title';
  static const String levelMaxScoreMessage = 'level_max_score_message';

  // Buttons & Common
  static const String confirm = 'confirm';
  static const String ok = 'ok';
  static const String back = 'back';
  static const String goHome = 'go_home';
  static const String loading = 'loading';
  static const String addLanguage = 'add_language';
  static const String errors = 'errors';
  static const String searchResult = 'search_result';
  static const String accuracy = 'accuracy';
  static const String time = 'time';
  static const String levelCompleted = 'level_completed';
  static const String dataNotFound = 'data_not_found';
  static const String errorWithText = 'error_with_text';
  static const String allow = 'allow';
  static const String levelHeader = 'level_header';
  static const String levelTasks = 'level_tasks';

  // Compliments
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

  // Errors
  static const String errorNameNull = 'error.name_null';
  static const String errorNameLengthSmall = 'error.name_length_small';
  static const String errorPasswordMin8 = 'error.password_min_8';
  static const String errorPasswordMustOneDigit = 'error.password_must_one_digit';
  static const String errorPasswordNotMatch = 'error.password_not_match';
  static const String errorSafe = 'error.error_safe';

  // Tips
  static const String tip1 = 'tips.tip_1';
  static const String tip2 = 'tips.tip_2';
  static const String tip3 = 'tips.tip_3';
  static const String tip4 = 'tips.tip_4';
  static const String tip5 = 'tips.tip_5';
  static const String tip6 = 'tips.tip_6';
  static const String tip7 = 'tips.tip_7';

  // Words
  static const String cookingDinner = 'words.cooking_dinner';
  static const String drinkingWater = 'words.drinking_water';
  static const String goingStore = 'words.going_store';
  static const String learningEnglish = 'words.learning_english';
  static const String readingBook = 'words.reading_book';
  static const String worksHospital = 'words.works_hospital';
  static const String playingFootball = 'words.playing_football';
  static const String studyingTogether = 'words.studying_together';
  static const String watchingMovie = 'words.watching_movie';
  static const String bigCity = 'words.big_city';
  static const String apple = 'words.apple';
  static const String book = 'words.book';
  static const String bread = 'words.bread';
  static const String car = 'words.car';
  static const String cat = 'words.cat';
  static const String chair = 'words.chair';
  static const String city = 'words.city';
  static const String dog = 'words.dog';
  static const String food = 'words.food';
  static const String house = 'words.house';
  static const String milk = 'words.milk';
  static const String moon = 'words.moon';
  static const String pen = 'words.pen';
  static const String phone = 'words.phone';
  static const String school = 'words.school';
  static const String student = 'words.student';
  static const String sun = 'words.sun';
  static const String table = 'words.table';
  static const String teacher = 'words.teacher';
  static const String water = 'words.water';
  static const String forest = 'words.forest';
  static const String window = 'words.window';
  static const String river = 'words.river';

  // Game answer words helper
  static String word(String key) => 'words.$key';
}
