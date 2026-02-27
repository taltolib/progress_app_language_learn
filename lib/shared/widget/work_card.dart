import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:progress/shared/widget/country_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:progress/core/providers/selected_language_provider.dart';
import 'package:progress/core/providers/translation_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/shared/widget/custom_show_dialog.dart';
import 'package:progress/shared/widget/language_search_field.dart';

class WordCard extends StatelessWidget {
  final String word;
  final String pronunciation;
  final String ru;
  final String uz;
  final bool isExact;

  const WordCard({
    super.key,
    required this.word,
    required this.pronunciation,
    required this.ru,
    required this.uz,
    required this.isExact,
  });

  @override
  Widget build(BuildContext context) {
    final translator = context.watch<TranslationProvider>();
    final selected = context.watch<SelectedLanguageProvider>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor =
    isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    final borderBaseColor =
    isDark ? AppColors.borderDark : AppColors.borderLight;

    final primaryTextColor =
    isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    final secondaryGrey =
    isDark ? AppColors.textSecondaryDark : Colors.grey.shade600;

    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: borderBaseColor,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              bottom: 8,
              left: 0,
              right: 0,
              child: Container(
                height: 210,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "[ $pronunciation ]",
                      style: TextStyle(
                        color: secondaryGrey,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                   Row(
                     children: [
                       Text(
                         'Рус ',
                         style: TextStyle(
                           color: secondaryGrey,
                           fontWeight: FontWeight.w600,
                           fontSize: 20
                         ),
                       ),
                       const SizedBox(width: 15),
                       Text(
                         ru,
                         style: TextStyle(
                           fontSize: 22,
                           color: primaryTextColor,
                         ),
                       ),
                     ],
                   ),
                    const SizedBox(height: 15),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: selected.code != null
                          ? _translationContainer(
                        context,
                        selected.code!,
                        translator.translatedText,
                        surfaceColor,
                      )
                          : _addButton(context, secondaryGrey, controller),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _addButton(
      BuildContext context,
      Color color,
      TextEditingController controller,
      ) {
    return InkWell(
      key: const ValueKey("add"),
      onTap: () {
        customShowBottomSheetDialog(
          context,
          0.9,
          SizedBox(
            height: 60,
            child: LanguageSearchField(controller: controller),
          ),
          CountryListWidget(word: word),
          null,
        );
      },
      child: Row(
        children: [
          Icon(Icons.add, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            "Добавить язык",
            style: TextStyle(
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _translationContainer(
      BuildContext context,
      String code,
      String text,
      Color surfaceColor,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderBaseColor =
    isDark ? AppColors.borderDark : AppColors.borderLight;

    final textColor =
    isDark ? Colors.white : Colors.black;

    final closeColor =
    isDark ? Colors.grey.shade400 : Colors.grey.shade800;

    return Container(
      height: 50,
      key: const ValueKey("translation"),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: surfaceColor,
        border: Border.all(color:borderBaseColor,width: 0.5 ),
        boxShadow: [
          BoxShadow(
            color: borderBaseColor.withOpacity(0.50),
            blurRadius: 3,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.read<SelectedLanguageProvider>().clear();
            },
            child: Icon(
              Icons.close,
              size: 18,
              color: closeColor,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          CountryFlag.fromCountryCode(
            code.toUpperCase(),
            theme: const ImageTheme(
              width: 30,
              height: 30,
              shape: Circle(),
            ),
          ),
        ],
      ),
    );
  }
}