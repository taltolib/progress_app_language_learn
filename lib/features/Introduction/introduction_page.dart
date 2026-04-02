import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/image/app_image.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/intro_template.dart';
import 'package:provider/provider.dart';
import '../../core/providers/introduction_provider.dart';
import '../../shared/widget/button.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<IntroductionProvider>();
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    List  title =[
      LocaleKeys.discoverTitle,
      LocaleKeys.progressTitle,
      LocaleKeys.practiceTitle,
    ];
    List subtitle =[
      LocaleKeys.discoverSubtitle,
      LocaleKeys.progressSubtitle,
      LocaleKeys.practiceSubtitle,
    ];
    List body =[
      LocaleKeys.discoverBody,
      LocaleKeys.progressBody,
      LocaleKeys.practiceBody,
      ];
    List  <Widget>animationPath =[
      AppImage().character.dance(width: 180,height: 180),
      AppImage().character.celebration(width: 180,height: 180),
      AppImage().character.excited(width: 180,height: 180),
    ];

    return Scaffold(
      backgroundColor:colors.backgroundWhiteOrDark,
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: PageView(
              onPageChanged: p.onPageChanged,
              controller: p.controller,
              children: List.generate(3, (index) => IntroTemplate(animationPath: animationPath[index], title: title[index], subtitle: subtitle[index], body: body[index],),)
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: p.currentPage == 0 ? 0 : 1,
                    child: Button(
                      icon: Icons.arrow_back_ios,
                      onTap: p.currentPage == 0 ? () {} : p.prev
                    ),
                  ),
                  Button(
                    onTap: () => p.next(context),
                    icon: Icons.arrow_forward_ios,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
