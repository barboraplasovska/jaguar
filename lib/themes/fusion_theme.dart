import 'package:flutter/material.dart';

final ThemeData fusionTheme = _fusionTheme();

ThemeData _fusionTheme() {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color(0xFFFF7F11),
      onPrimary: const Color(0xFF050401),
      secondary: const Color(0xFF303036),
      onSecondary: const Color(0xFFF5F5F5),
      tertiary: const Color(0xFF058ED9),
      onTertiary: const Color(0xFFF5F5F5),
      background: const Color(0xFFF5F5F5),
      onBackground: const Color(0xFF050401),
      primaryContainer: const Color(0xFF303036),
    ),
  );
}
