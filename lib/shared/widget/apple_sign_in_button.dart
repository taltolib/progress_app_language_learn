import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/providers/auth_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/shared/widget/push_button.dart';
import 'package:provider/provider.dart';


class AppleSignInButton extends StatelessWidget {

  final String redirectRoute;

  const AppleSignInButton({
    super.key,
    this.redirectRoute = '/home',
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.status.name == 'loading';

    return PushButton(
      height: 70,
      color: Colors.white,
      colorShadow: const Color(0xFFDADADA),
      colorText: const Color(0xFF3C4043),
      border: Border.all(width: 1.5, color: const Color(0xFFDADADA)),
      borderRadius: 15,
      language: isLoading ? 'Загрузка...' : 'Войти с Google',
      isSelected: false,
      flagAsset: isLoading
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.green,
        ),
      )
          : Image.network(
        'https://www.google.com/favicon.ico',
        width: 24,
        height: 24,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.g_mobiledata,
          size: 28,
          color: Color(0xFF4285F4),
        ),
      ),
      onTap: isLoading
          ? () {}
          : () async {
        final success =
        await context.read<AuthProvider>().signInWithGoogle();
        if (success && context.mounted) {
          context.go(redirectRoute);
        } else if (!success && context.mounted) {
          final error = context.read<AuthProvider>().errorMessage;
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      },
    );
  }
}