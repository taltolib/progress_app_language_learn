import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/providers/create_profile_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/shared/widget/%20top_snackbar.dart';
import 'package:progress/shared/widget/push_button.dart';
import 'package:provider/provider.dart';

class CreateProfilePage extends StatelessWidget {
  const CreateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final prov = context.watch<CreateProfileProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.backgroundWhiteOrDark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.38,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.38,
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
                        const SizedBox(height: 60),
                        const SizedBox(height: 16),
                        Text(
                          'Создание профиля',
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
                       _buildField(
                        controller: prov.nameController,
                        hint: 'Ваше имя',
                        colors: colors,
                      ),
                      const SizedBox(height: 16),

                       _buildField(
                        controller: prov.passwordController,
                        hint: 'Придумайте пароль',
                        colors: colors,
                        isPassword: true,
                        obscure: prov.obscurePassword,
                        onToggle: prov.togglePassword,
                      ),
                      const SizedBox(height: 16),


                      _buildField(
                        controller: prov.confirmPasswordController,
                        hint: 'Повторите пароль',
                        colors: colors,
                        isPassword: true,
                        obscure: prov.obscureConfirm,
                        onToggle: prov.toggleConfirm,
                      ),
                      const SizedBox(height: 28),


                      PushButton(
                        height: 70,
                        color: AppColors.green,
                        colorShadow: AppColors.blackGreen,
                        border: Border.all(
                          width: 2,
                          color: AppColors.blackGreen,
                        ),
                        fontSize: 18,
                        colorText: AppColors.whiteForLight,
                        borderRadius: 15,
                        language: prov.isLoading ? 'Сохранение...' : 'Готово!',
                        flagAsset: prov.isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const SizedBox.shrink(),
                        onTap: prov.isLoading
                            ? () {}
                            : () async {

                          final error = prov.validate();
                          if (error != null) {
                            TopSnackBar.show(context, error);
                            return;
                          }

                          final success = await prov.saveProfile();
                          if (!context.mounted) return;

                          if (success) {
                            context.go('/main');
                          } else {
                            TopSnackBar.show(
                              context,
                              prov.errorMessage ?? 'Ошибка сохранения',
                            );
                          }
                        },
                        isSelected: false,
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

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required AppThemeColors colors,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: colors.backgroundWhiteOrDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        style: TextStyle(color: colors.text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:  TextStyle(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? GestureDetector(
            onTap: onToggle,
            child: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: colors.text,
              size: 20,
            ),
          )
              : null,
        ),
      ),
    );
  }
}