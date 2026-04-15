import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:progress/core/providers/word_detail_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/domain/models/card_content_model.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/shared/widget/app_bar_custom_for_card_page.dart';
import 'package:provider/provider.dart';

class CardPage extends StatefulWidget {
  final int wordId;
  final CardContentType type;

  const CardPage({
    super.key,
    required this.wordId,
    required this.type,
  });

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WordDetailProvider>().loadDetail(widget.wordId);
    });
  }

  String _getBodyForType(WordDetailProvider provider) {
    final detail = provider.detail;
    if (detail == null) return '';
    switch (widget.type) {
      case CardContentType.grammar:
        return detail.grammarBody ?? '';
      case CardContentType.differences:
        return detail.differenceBody ?? '';
      case CardContentType.thesaurus:
        return detail.thesaurusBody ?? '';
      case CardContentType.collocations:
        return detail.collocationBody ?? '';
      case CardContentType.metaphors:
        return detail.metaphorBody ?? '';
      case CardContentType.speaking:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Consumer<WordDetailProvider>(
      builder: (context, provider, _) {
        final title = provider.detail?.word ?? '';
        final body = _getBodyForType(provider);
        return Scaffold(
          backgroundColor: colors.backgroundWhiteOrDark,
          appBar: appBarCustom(context, widget.type.label),
          body: provider.isLoading
              ?  Center(child: CircularProgressIndicator(color: AppColors.green,))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.backgroundAcceptsWhiteOrDark,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 28, 12, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title.isNotEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Text(
                                title,
                                style: AppFonts.mulish.s20w700(color: colors.text),
                              ),
                            ),
                          ),
                        if (body.isNotEmpty)
                          Html(
                            data: body,
                            style: {
                              "body": Style(
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                                fontSize: FontSize(16),
                                color: colors.text,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                lineHeight: const LineHeight(1.5),
                              ),
                              "p": Style(
                                margin: Margins.only(bottom: 12),
                              ),
                              "strong": Style(
                                fontWeight: FontWeight.bold,
                                color: colors.text,
                              ),
                              "b": Style(
                                fontWeight: FontWeight.bold,
                                color: colors.text,
                              ),
                              "i": Style(
                                fontStyle: FontStyle.italic,
                                // ignore: deprecated_member_use
                                color: colors.text.withOpacity(0.9),
                              ),
                              "li": Style(
                                margin: Margins.only(bottom: 8),
                              ),
                              "ul": Style(
                                margin: Margins.only(bottom: 16),
                              ),
                            },
                          )
                        else
                          Center(
                            child: Text(
                              'No content available',
                              style: AppFonts.mulish.s15w500(
                                // ignore: deprecated_member_use
                                color: colors.text.withOpacity(0.5),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}