import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';

class LanguageList extends StatelessWidget {
  List<Widget> list = [];
  List<String> title = [];
  final int selectedIndex;
  final ValueChanged<int> onTap;

  LanguageList({super.key, required this.list, required this.title, required this.onTap, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final bool isActive = index == selectedIndex;
        return GestureDetector(
          onTap: () => onTap(index),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.brandGreen
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).dividerColor.withOpacity(0.50),
                    blurRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  list[index],
                  const SizedBox(width: 10),
                  Text(
                    title[index],
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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
