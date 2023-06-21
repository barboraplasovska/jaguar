import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileProvider extends ChangeNotifier {
  FileSystemEntity? _selectedFile;

  FileSystemEntity? get selectedFile => _selectedFile;

  set selectedFile(FileSystemEntity? file) {
    _selectedFile = file;
    notifyListeners();
  }

  static FileProvider create(BuildContext context) {
    return Provider.of<FileProvider>(context, listen: false);
  }
}
