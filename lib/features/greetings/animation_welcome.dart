import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors/app_colors.dart'; // путь поправь под себя

class AnimationWelcome extends StatefulWidget {
  const AnimationWelcome({super.key});

  @override
  State<AnimationWelcome> createState() => _AnimationWelcomeState();
}

class _AnimationWelcomeState extends State<AnimationWelcome>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.push('/introduction');
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandGreen, // 🟢 ВСЕГДА зелёный
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Text(
              'Progress',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.brandOnGreen, // ⚪ ВСЕГДА белый
              ),
            ),
          ),
        ),
      ),
    );
  }
}
