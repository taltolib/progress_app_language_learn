import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:progress/core/providers/theme_provider.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Темная тема",
              style: TextStyle(fontSize: 16),
            ),
          ),
          GestureDetector(
            onTap: () {
              themeProvider.toggleTheme(!isDark);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 70,
              height: 36,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: isDark
                    ? const LinearGradient(
                  colors: [
                    Color(0xFF0D1B2A),
                    Color(0xFF1B263B),
                  ],
                )
                    : const LinearGradient(
                  colors: [
                    Color(0xFF87CEEB),
                    Color(0xFFFFD54F),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  if (isDark)
                    const Positioned(
                      left: 8,
                      top: 8,
                      child: Icon(
                        Icons.star,
                        size: 6,
                        color: Colors.white70,
                      ),
                    ),
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: isDark
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? const Color(0xFFF4E3C1)
                            : const Color(0xFFFFB300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isDark
                            ? Icons.nightlight_round
                            : Icons.wb_sunny,
                        size: 16,
                        color: isDark
                            ? Colors.brown
                            : Colors.white,
                      ),
                    ),
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