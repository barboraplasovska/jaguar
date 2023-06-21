import 'dart:io';

import 'package:flutter/material.dart';

class FileDetail extends StatelessWidget {
  final FileSystemEntity? selectedFile;

  const FileDetail({
    super.key,
    this.selectedFile,
  });

  @override
  Widget build(BuildContext context) {
    return selectedFile != null
        ? Text(selectedFile.toString())
        : const Text("No file open");
  }
}
