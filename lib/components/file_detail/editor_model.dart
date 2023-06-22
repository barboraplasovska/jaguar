import 'package:flutter/material.dart';
import 'package:pingfrontend/components/file_detail/editor_model_style.dart';

import 'file_editor.dart';

/// Use the EditorModel into CodeEditor in order to control the editor.
///
/// EditorModel extends ChangeNotifier because we use the provider package
/// to simplify the work.
class EditorModel extends ChangeNotifier {
  late int _currentPositionInFiles;
  bool _isEditing = false;
  late List<String?> _languages;
  late List<FileEditor> allFiles;
  EditorModelStyle? styleOptions;

  EditorModel({required List<FileEditor> files, this.styleOptions}) {
    if (this.styleOptions == null) {
      this.styleOptions = EditorModelStyle();
    }
    _languages = [];
    _currentPositionInFiles = 0;
    /*if (files.length == 0) {
      files.add(
        FileEditor(
          name: "index.html",
          language: "html",
          code: "",
        ),
      );
    }*/
    for (var file in files) {
      _languages.add(file.language);
    }
    allFiles = files;
  }

  List<String?> getCodeWithLanguage(String language) {
    List<String?> listOfCode = [];
    for (var file in allFiles) {
      if (file.language == language) {
        listOfCode.add(file.code);
      }
    }
    return listOfCode;
  }

  String? getCodeWithIndex(int index) {
    return allFiles[index].code;
  }

  FileEditor getFileWithIndex(int index) {
    return allFiles[index];
  }

  void changeIndexTo(int i) {
    if (_isEditing) {
      return;
    }
    _currentPositionInFiles = i;
    notify();
  }

  void closeFile(FileEditor file) {
    allFiles.remove(file);
    print(allFiles.map((e) => e.name));

    notify();

    if (numberOfFiles > 0) changeIndexTo(0);
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notify();
  }

  void updateCodeOfIndex(int index, String? newCode) {
    allFiles[index].code = newCode;
  }

  void notify() => notifyListeners();

  int? get position => _currentPositionInFiles;

  String? get currentLanguage => allFiles[_currentPositionInFiles].language;

  bool get isEditing => _isEditing;

  int get numberOfFiles => allFiles.length;
}
