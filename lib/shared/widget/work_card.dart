import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';


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
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.backgroundAcceptsWhiteOrDark,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                en,
                style: AppFonts.mulish.s30w700(color: colors.text),
              ),
            ),
            const SizedBox( height: 5,),
            Flexible(
              child: Text(
                "[$pronunciation]",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.mulish.s18w400(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: Row(
                children: [
                  Expanded(child: Text('🇷🇺', style: TextStyle(fontSize: 30))),
                  Expanded(
                    flex: 5,
                    child: Text(
                      ru,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.mulish.s22w600(color: colors.text),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  Expanded(child: Text('🇺🇿', style: TextStyle(fontSize: 30))),
                  Expanded(
                    flex: 5,
                    child: Text(
                      uz,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.mulish.s22w600(color: colors.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _addButton(
  //   BuildContext context,
  //   Color color,
  //   TextEditingController controller,
  // ) {
  //   return InkWell(
  //     key: const ValueKey("add"),
  //     onTap: () {
  //       customShowBottomSheetDialog(
  //         context,
  //         0.9,
  //         SizedBox(
  //           height: 60,
  //           child: LanguageSearchField(
  //             controller: controller,
  //             hintText: "Начните вводить слово",
  //           ),
  //         ),
  //         CountryListWidget(word: en),
  //         null,
  //       );
  //     },
  //     child: Row(
  //       children: [
  //         Icon(Icons.add, size: 18, color: color),
  //         const SizedBox(width: 6),
  //         Text("Добавить язык", style: AppFonts.mulish.s16w400(color: color)),
  //       ],
  //     ),
  //   );
  // }
}
