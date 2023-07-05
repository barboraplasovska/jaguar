import 'package:flutter/material.dart';

final ThemeData tigerTheme = _tigerTheme();

ThemeData _tigerTheme() {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color(0xFFFF7F11),
      onPrimary: const Color(0xFF050401),
      secondary: const Color(0xFFF5F5F5),
      onSecondary: const Color(0xFF303036),
      tertiary: const Color(0xFF050401),
      onTertiary: const Color(0xFFF5F5F5),
      background: const Color(0xFF1E1E1E),
      onBackground: const Color(0xFF323233),
      primaryContainer: const Color(0xFF252526),
      onPrimaryContainer: const Color(0xFFF5F5F5),
    ),
  );
}
