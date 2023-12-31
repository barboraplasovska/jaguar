import 'package:flutter/material.dart';

final ThemeData fusionTheme = _fusionTheme();

ThemeData _fusionTheme() {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color(0xFFAC3931),
      onPrimary: const Color(0xFF050401),
      secondary: const Color(0xFFF5F5F5),
      onSecondary: const Color(0xFF303036),
      tertiary: const Color(0xFF058ED9),
      onTertiary: const Color(0xFFF5F5F5),
      background: const Color(0xFF1E1E1E),
      onBackground: const Color(0xFF323233),
      primaryContainer: const Color(0xFF252526),
      onPrimaryContainer: const Color(0xFFF5F5F5),
    ),
  );
}
