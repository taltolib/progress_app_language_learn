import 'package:go_router/go_router.dart';
import 'package:progress/features/language/learning_language_page.dart';
import 'package:progress/features/translation/language_selection_page.dart';
import 'package:progress/shared/widget/main_scaffold.dart';
import '../../features/Introduction/introduction_page.dart';
import '../../features/greetings/animation_welcome.dart';
import 'package:flutter/material.dart';
import '../../shared/widget/hole_clipper.dart';

final GoRouter router = GoRouter(
  routes: [

    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return const MaterialPage(child: AnimationWelcome());
      },
    ),

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
                  builder: (context, _) {
                    return ClipPath(
                      clipper: HoleClipper(hole.value),
                      child: Container(color: Colors.green),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    ),

    GoRoute(
      path: '/translation',
      pageBuilder: (context, state) =>
      const MaterialPage(child: LanguageSelectionPage()),
    ),

    GoRoute(
      path: '/language',
      pageBuilder: (context, state) =>
          MaterialPage(child: LearningLanguagePage()),
    ),

    GoRoute(
      path: '/main',
      pageBuilder: (context, state) =>
          MaterialPage(child: MainScaffold()),
    ),
  ],
);