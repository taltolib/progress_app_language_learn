import 'package:flutter/material.dart';
import 'package:progress/core/providers/favorites_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/domain/models/word_model.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:provider/provider.dart';

class WordCard extends StatelessWidget {
  final SearchResult result;

  const WordCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeColors>()!;
    final favProv = context.watch<FavoritesProvider>();
    final isFav = favProv.isFavorite(result.id);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    result.word,
                    style: AppFonts.mulish.s30w700(color: colors.text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.read<FavoritesProvider>().toggle(result),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: child,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(isFav),
                      color: isFav ? AppColors.green : colors.text,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Flexible(
              child: Text(
                "[${result.pronunciation ?? ''}]",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.mulish.s18w400(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: Row(
                children: [
                  Expanded(child: Text('🇷🇺', style: const TextStyle(fontSize: 30))),
                  Expanded(
                    flex: 5,
                    child: Text(
                      result.wordRu ?? '',
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
                  Expanded(child: Text('🇺🇿', style: const TextStyle(fontSize: 30))),
                  Expanded(
                    flex: 5,
                    child: Text(
                      result.wordUz ?? '',
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
}