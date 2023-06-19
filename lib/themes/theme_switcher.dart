import 'package:flutter/material.dart';
import 'package:pingfrontend/themes/fusion_theme.dart';
import 'package:pingfrontend/themes/java_theme.dart';
import 'package:pingfrontend/themes/tiger_theme.dart';

enum AppTheme { tiger, java, fusion }

class ThemeSwitcher extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.fusion;

  ThemeData get currentTheme {
    switch (_currentTheme) {
      case AppTheme.tiger:
        return tigerTheme;
      case AppTheme.java:
        return javaTheme;
      case AppTheme.fusion:
        return fusionTheme;
      default:
        return fusionTheme; // Set a default theme if needed
    }
  }

  AppTheme get currentThemeOption => _currentTheme;

  void switchTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
