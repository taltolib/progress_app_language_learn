import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/search_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/shared/widget/work_card.dart' show WordCard;
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/language_search_field.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          LanguageSearchField(
            controller: _controller,
            hintText: LocaleKeys.searchResult.tr(),
            onChanged: (value) {
              setState(() {});
              provider.search(value);
            },
          ),
          const SizedBox(height: 12),
         Expanded(child: _buildSearch(provider)),
        ],
      ),
    );
  }


  Widget _buildSearch(SearchProvider provider) {
    if (_controller.text.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys.writeWord.tr(),
          style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        ),
      );
    }
    if (provider.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.green),
      );
    }
    if (provider.results.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys.dataNotFound.tr(),
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }

    return ListView.builder(
      itemCount: provider.results.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return WordCard(result: provider.results[index],);
      },
    );
  }
}
