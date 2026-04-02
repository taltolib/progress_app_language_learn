// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:progress/core/providers/language_provider.dart';
// import 'package:progress/core/theme/colors/app_colors.dart';
// import 'package:provider/provider.dart';
//
// class LanguageCard extends StatelessWidget {
//   final String language;
//   final Widget flagAsset;
//
//   const LanguageCard({
//     super.key,
//     required this.language,
//     required this.flagAsset,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<LanguageProvider>();
//     final isSelected = provider.selectedLanguage == language;
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     final surfaceColor =
//     isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
//
//     final borderBaseColor =
//     isDark ? AppColors.borderDark : AppColors.borderLight;
//
//     final textColor = isSelected
//         ? Colors.white
//         : (isDark
//         ? AppColors.textPrimaryDark
//         : AppColors.textPrimaryLight);
//
//     return GestureDetector(
//       onTap: () {
//         provider.selectLanguage(language);
//         context.go('/main');
//       },
//       child: SizedBox(
//         height: 140,
//         child: Stack(
//           children: [
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? AppColors.brandGreenPressed
//                       : borderBaseColor,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//             ),
//
//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 120),
//               bottom: isSelected ? 10 : 5,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? AppColors.brandGreen
//                       : surfaceColor,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     flagAsset,
//                     const SizedBox(width: 12),
//                     Text(
//                       language.tr(),
//                       style: TextStyle(
//                         color: textColor,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }