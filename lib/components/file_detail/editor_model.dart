import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pingfrontend/components/file_detail/editor_model_style.dart';
import 'file_editor.dart';

class EditorModel extends ChangeNotifier {
  late int _currentPositionInFiles;
  bool _isEditing = false;
  late List<String?> _languages;
  late List<FileEditor> allFiles;
  EditorModelStyle? styleOptions;

  EditorModel({required List<FileEditor> files, this.styleOptions}) {
    styleOptions ??= EditorModelStyle();
    _languages = [];
    _currentPositionInFiles = 0;
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

  void updateCodeOfIndex(int index, String? newCode) async {
    allFiles[index].code = newCode;

    var file = File(allFiles[index].path);

    var sink = file.openWrite();
    sink.write(allFiles[index].code);
    sink.close();
  }

  void notify() => notifyListeners();

  int? get position => _currentPositionInFiles;

  String? get currentLanguage => allFiles[_currentPositionInFiles].language;

  bool get isEditing => _isEditing;

  int get numberOfFiles => allFiles.length;
}
