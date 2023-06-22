import 'package:flutter/material.dart';
import 'package:pingfrontend/themes/fusion_theme.dart';

import 'editor_theme.dart';

class EditorModelStyle {
  final EdgeInsets padding;

  final double heightOfContainer;

  final Map<String, TextStyle> theme;

  final String fontFamily;

  final double? letterSpacing;

  final double fontSize;

  final double lineHeight;

  final int tabSize;

  final Color editorColor;

  final Color editorBorderColor;

  final Color editorFilenameColor;

  final Color editorToolButtonColor;

  final Color editorToolButtonTextColor;

  final double? fontSizeOfFilename;

  final TextStyle textStyleOfTextField;

  final Color editButtonBackgroundColor;

  final Color editButtonTextColor;

  final String editButtonName;

  final bool placeCursorAtTheEndOnEdit;

  final Color editorTabSelectedColor;
  final Color editorTabColor;
  final Color editorTabTextColor;

  static const Color defaultColorEditor = Color(0xFF1E1E1E);
  static const Color defaultColorBorder = Color(0xFFFF7F11);
  static const Color defaultColorFileName = Color(0xFF6CD07A);
  static const Color defaultToolButtonColor = Color(0xFF4650c7);
  static const Color defaultEditBackgroundColor = Color(0xFFEEEEEE);

  static const Color defaultEditorTabSelectedColor = Color(0xFF1E1E1E);
  static const Color defaultEditorTabColor = Color(0xFF2D2D2D);
  static const Color defaultEditorTabTextColor = Color(0xFFF5F5F5);

  EditorModelStyle({
    this.padding = const EdgeInsets.all(15.0),
    this.heightOfContainer = 300,
    this.theme = editorTheme,
    this.fontFamily = "monospace",
    this.letterSpacing,
    this.fontSize = 15,
    this.lineHeight = 1.6,
    this.tabSize = 2,
    this.editorColor = defaultColorEditor,
    this.editorBorderColor = defaultColorBorder,
    this.editorFilenameColor = defaultColorFileName,
    this.editorToolButtonColor = defaultToolButtonColor,
    this.editorToolButtonTextColor = Colors.white,
    this.editButtonBackgroundColor = defaultEditBackgroundColor,
    this.editButtonTextColor = Colors.black,
    this.editButtonName = "Edit",
    this.fontSizeOfFilename = 12,
    this.textStyleOfTextField = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
      letterSpacing: 1.25,
      fontWeight: FontWeight.w500,
    ),
    this.placeCursorAtTheEndOnEdit = true,
    this.editorTabSelectedColor = defaultEditorTabSelectedColor,
    this.editorTabColor = defaultEditorTabColor,
    this.editorTabTextColor = defaultEditorTabTextColor,
  });

  double? editButtonPosTop;
  double? editButtonPosLeft;
  double? editButtonPosBottom = 10;
  double? editButtonPosRight = 15;

  void defineEditButtonPosition({
    required top,
    left,
    bottom,
    right,
  }) {
    editButtonPosTop = top;
    editButtonPosLeft = left;
    editButtonPosBottom = bottom;
    editButtonPosRight = right;
  }
}
