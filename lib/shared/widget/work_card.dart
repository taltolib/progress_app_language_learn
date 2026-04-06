import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/shared/widget/country_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:progress/core/providers/selected_language_provider.dart';
import 'package:progress/core/providers/translation_provider.dart';
import 'package:progress/shared/widget/custom_show_dialog.dart';
import 'package:progress/shared/widget/language_search_field.dart';

class WordCard extends StatelessWidget {
  final String en;
  final String pronunciation;
  final String ru;
  final String uz;


  const WordCard({
    super.key,
    required this.en,
    required this.pronunciation,
    required this.ru,
    required this.uz,
  });

  @override
  Widget build(BuildContext context) {
    final translator = context.watch<TranslationProvider>();
    final selected = context.watch<SelectedLanguageProvider>();
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeColors>()!;

    final borderBaseColor = colors.borderBlack;
    final primaryTextColor = colors.textBlack;
    final secondaryGrey = colors.textGrey;
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
                  color: colors.backgroundAcceptsWhiteOrDark ,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          en,
                          style: AppFonts.mulish.s30w700(
                            color: primaryTextColor,
                          ),
                        ),
                        Text(
                          "[ $pronunciation ]",
                          style: AppFonts.mulish.s18w400(
                            color: secondaryGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ru,
                      style: AppFonts.mulish.s22w600(
                        color: primaryTextColor,
                      ),
                    ),
                    Text(
                      uz,
                      style: AppFonts.mulish.s22w600(
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 15),
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
            child: LanguageSearchField(controller: controller , hintText: "Начните вводить слово"),
          ),
          CountryListWidget(word: en),
          null,
        );
      },
      child: Row(
        children: [
          Icon(Icons.add, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            "Добавить язык",
            style: AppFonts.mulish.s16w400(
              color: color,
            ),
          ),
        ],
      ),
    );
  }


}