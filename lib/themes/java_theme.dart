import 'package:flutter/material.dart';

final ThemeData javaTheme = _javaTheme();

ThemeData _javaTheme() {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color(0xFF058ED9),
      onPrimary: const Color(0xFFF5F5F5),
      secondary: const Color(0xFFFF7F11),
      onSecondary: const Color(0xFF050401),
      tertiary: const Color(0xFFAC3931),
      onTertiary: const Color(0xFFF5F5F5),
      background: const Color(0xFFF5F5F5),
      onBackground: const Color(0xFF050401),
      primaryContainer: const Color(0xFF303036),
    ),
  );
}
