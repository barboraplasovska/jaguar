import 'package:flutter/material.dart';
import 'package:ping/themes/fusion_theme.dart';
import 'package:ping/themes/java_theme.dart';
import 'package:ping/themes/tiger_theme.dart';

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

  String get currentThemePicture {
    switch (_currentTheme) {
      case AppTheme.tiger:
        return "assets/images/tiger.png";
      case AppTheme.java:
        return "assets/images/java.png";
      case AppTheme.fusion:
        return "assets/images/fusion.png";
      default:
        return "assets/images/fusion.png";
    }
  }

  AppTheme get currentThemeOption => _currentTheme;

  void switchTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
