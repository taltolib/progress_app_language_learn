import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';

class LanguageSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;


  const LanguageSearchField({super.key, required this.controller, required this.hintText, this.onChanged});

  @override

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeColors>()!;

    return TextFormField(
      controller: controller,
      cursorColor: theme.colorScheme.primary,
      style: TextStyle(
        color: colors.textBlack,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: TextStyle(
          color: colors.textGrey,
        ),

        prefixIcon: Icon(
          Icons.search,
          color: colors.textGrey,
        ),

        filled: true,
        fillColor: colors.backgroundWhiteOrDark,

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.borderBlack,
          ),
          borderRadius: BorderRadius.circular(14),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:AppColors.green,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}