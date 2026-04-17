import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/hive/app_prefs.dart';
import 'package:progress/core/providers/auth_provider.dart';
import 'package:progress/core/providers/login_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/image/app_image.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/google_sign_in_button.dart';
import 'package:progress/shared/widget/push_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final prov = context.watch<LoginProvider>();
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
                          LocaleKeys.entry.tr(),
                          style: AppFonts.mulish.s24w700(color: Colors.white),
                        ),
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
                              horizontal: 16,
                              vertical: 16
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16 ),
                              decoration: BoxDecoration(
                                color: colors.backgroundWhiteOrDark,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: TextField(
                                controller: prov.phoneController,
                                style: TextStyle(color: colors.text),
                                keyboardType: TextInputType.phone,
                                maxLength: 9,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  counterText: '',
                                  hintText: '901234567',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: colors.backgroundWhiteOrDark,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: TextField(
                          controller: prov.passwordController,
                          obscureText: prov.obscurePassword,
                          style: TextStyle(color: colors.text),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]'),
                            ),
                          ],
                          decoration: InputDecoration(
                            hintText: LocaleKeys.password.tr(),
                            hintStyle: const TextStyle(color: Colors.grey ,fontSize: 14),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                            suffixIcon: GestureDetector(
                              onTap: prov.togglePasswordVisibility,
                              child: Icon(
                                prov.obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: colors.text,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      PushButton(
                        height: 70,
                        color: AppColors.green,
                        colorShadow: AppColors.blackGreen,
                        border: Border.all(width: 2, color: AppColors.blackGreen),
                        fontSize: 18,
                        colorText: AppColors.whiteForLight,
                        borderRadius: 15,
                        language: prov.isLoading ? LocaleKeys.loading.tr() : LocaleKeys.login.tr(),
                        flagAsset: prov.isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ) : const SizedBox.shrink(),
                        onTap: prov.isLoading ? () {} : () {
                          prov.handleLogin(context, context.read<AuthProvider>(),);
                         !AppPrefs.isSeen;
                        } ,
                        isSelected: false,
                      ),
                      GoogleSignInButton(redirectRoute: '/main'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.noAccount.tr(),
                            style: AppFonts.mulish.s14w400(color: Colors.grey),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: Text(
                              LocaleKeys.register.tr(),
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