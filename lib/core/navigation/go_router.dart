import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/hive/app_prefs.dart';
import 'package:progress/core/providers/auth_provider.dart';
import 'package:progress/core/providers/otp_provider.dart';
import 'package:progress/domain/models/card_content_model.dart';
import 'package:progress/features/create/create_profile_page.dart';
import 'package:progress/features/login/login_page.dart';
import 'package:progress/features/otp/otp_page.dart';
import 'package:progress/features/register/register_page.dart';
import 'package:progress/shared/widget/card_page.dart';
import 'package:progress/shared/widget/main_scaffold.dart';
import 'package:progress/shared/widget/task_page.dart';
import 'package:provider/provider.dart';
import '../../features/Introduction/introduction_page.dart';
import '../../features/greetings/animation_welcome.dart';
import '../../shared/widget/hole_clipper.dart';

GoRouter buildRouter(AuthProvider authProvider) {
  return GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final introSeen = AppPrefs.introSeen;
      final location = state.matchedLocation;
      if (!introSeen) {
        return location == '/introduction' ? null : '/introduction';
      }

      if (!isLoggedIn) {
        const guestRoutes = ['/login', '/register', '/otp', '/create_profile'];
        return guestRoutes.contains(location) ? null : '/login';
      }
      if (location == '/login' || location == '/register') return '/main';

      if (location == '/') return '/main';

      return null;
    },
    routes: [
      GoRoute(
        path: '/introduction',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 600),
            child: const IntroductionPage(),
            transitionsBuilder: (context, animation, _, child) {
              final hole = Tween<double>(begin: 0, end: 2000).animate(animation);
              return Stack(
                children: [
                  child,
                  AnimatedBuilder(
                    animation: hole,
                    builder: (context, _) => ClipPath(
                      clipper: HoleClipper(hole.value),
                      child: Container(color: Colors.green),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => MaterialPage(child: RegisterPage()),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final phone = state.extra as String;
          return ChangeNotifierProvider(
            create: (_) => OtpProvider(),
            child: OtpPage(phone: phone),
          );
        },
      ),
      GoRoute(
        path: '/create_profile',
        pageBuilder: (context, state) => MaterialPage(child: CreateProfilePage()),
      ),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(child: AnimationWelcome()),
      ),
      GoRoute(
        path: '/card',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final wordId = extra['wordId'] as int;
          final type = extra['type'] as CardContentType;
          return CardPage(wordId: wordId, type: type);
        },
      ),
      GoRoute(
        path: '/main',
        pageBuilder: (context, state) => MaterialPage(child: MainScaffold()),
      ),
      GoRoute(
        path: '/level/:id',
        pageBuilder: (context, state) {
          final levelId = int.parse(state.pathParameters['id']!);
          return MaterialPage(child: TaskPage(id: levelId));
        },
      ),
    ],
  );
}