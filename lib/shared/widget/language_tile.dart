import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LanguageTile extends StatelessWidget {
  final Widget flag;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color textPrimary;

  const LanguageTile({
    required this.flag,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(

          vertical: 6,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            flag,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textPrimary,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}