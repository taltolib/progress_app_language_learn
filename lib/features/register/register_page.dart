import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/providers/auth_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/domain/enums/auth_status.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/image/app_image.dart';
import 'package:progress/shared/widget/%20top_snackbar.dart';
import 'package:progress/shared/widget/push_button.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final authProv = context.watch<AuthProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.backgroundWhiteOrDark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.42,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.42,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                      border: Border.all(width: 2, color: AppColors.blackGreen),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        AppImage().character.happy(height: 120),
                        const SizedBox(height: 16),
                        Text(
                          'Регистрация',
                          style: AppFonts.mulish.s24w700(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: colors.backgroundAcceptsWhiteOrDark,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: colors.shadow.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 17,
                            ),
                            decoration: BoxDecoration(
                              color: colors.backgroundWhiteOrDark,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Text(
                              '🇺🇿 +998',
                              style: AppFonts.mulish.s14w600(color: colors.text),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: colors.backgroundWhiteOrDark,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: TextField(
                                controller: authProv.phoneController,
                                style: TextStyle(color: colors.text),
                                keyboardType: TextInputType.phone,
                                maxLength: 9,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  counterText: '',
                                  hintText: '901234567',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      PushButton(
                        height: 70,
                        color: AppColors.green,
                        colorShadow: AppColors.blackGreen,
                        border: Border.all(width: 2, color: AppColors.blackGreen),
                        fontSize: 18,
                        colorText: AppColors.whiteForLight,
                        borderRadius: 15,
                        language: authProv.status == AuthStatus.loading
                            ? 'Отправка...'
                            : 'Получить код',
                        flagAsset: authProv.status == AuthStatus.loading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const SizedBox.shrink(),
                        onTap: authProv.status == AuthStatus.loading
                            ? () {}
                            : () async {
                          final phone = authProv.phoneController.text.trim();
                          if (phone.isEmpty || phone.length < 9) {
                            TopSnackBar.show(context, 'Введите корректный номер (9 цифр)');
                            return;
                          }

                          // ← НОВАЯ ПРОВЕРКА
                          final exists = await authProv.isPhoneAlreadyRegistered(phone);
                          if (!context.mounted) return;
                          if (exists) {
                            TopSnackBar.show(context, 'Аккаунт с этим номером уже существует');
                            return;
                          }

                          authProv.sendOtp(phone);

                          await Future.doWhile(() async {
                            await Future.delayed(const Duration(milliseconds: 300));
                            return authProv.status == AuthStatus.loading;
                          });

                          if (!context.mounted) return;

                          if (authProv.status == AuthStatus.codeSent) {
                            context.go('/otp', extra: phone);
                          } else if (authProv.status == AuthStatus.error) {
                            TopSnackBar.show(
                              context,
                              authProv.errorMessage ?? 'Ошибка отправки SMS',
                            );
                          }
                        },
                        isSelected: false,
                      ),
                      const SizedBox(height: 16),

                      // ── Назад на логин ─────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Уже есть аккаунт? ',
                            style: AppFonts.mulish.s14w400(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/login'),
                            child: Text(
                              'Войти',
                              style: AppFonts.mulish.s14w700(
                                color: AppColors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}