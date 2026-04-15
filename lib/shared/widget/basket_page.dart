import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/favorites_provider.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/app_bar_custom_for_card_page.dart';
import 'package:progress/shared/widget/work_card.dart' show WordCard;
import 'package:provider/provider.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final favProv = context.watch<FavoritesProvider>();
    return Scaffold(
      backgroundColor: colors.backgroundWhiteOrDark,
      appBar: appBarCustom(context, LocaleKeys.favoriteWord.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: _buildFavorites(favProv),
      ),
    );
  }

  Widget _buildFavorites(FavoritesProvider favProv) {
    if (favProv.favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.noFavoriteWords.tr(),
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              LocaleKeys.pushForLike.tr(),
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: favProv.favorites.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return WordCard(result: favProv.favorites[index]);
      },
    );
  }
}