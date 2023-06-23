import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path/path.dart';

import 'code_editor.dart';
import 'editor_model.dart';
import 'editor_model_style.dart';
import 'file_editor.dart';

class FileDetail extends StatefulWidget {
  final FileSystemEntity? selectedFile;

  const FileDetail({
    super.key,
    this.selectedFile,
  });

  @override
  State<FileDetail> createState() => _FileDetailState();
}

class _FileDetailState extends State<FileDetail> {
  List<FileEditor> tabs = [];
  String lastFileContent = "";

  Future<String> readFile(FileSystemEntity fileEntity) async {
    try {
      if (fileEntity is File) {
        List<String> lines = await fileEntity.readAsLines();
        return lines.join("\n");
      } else {
        return 'Error: The provided entity is not a file.';
      }
    } catch (e) {
      return 'Error reading file: ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedFile == null) {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'No file',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder<String>(
            future: readFile(widget.selectedFile!),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                String content = snapshot.data!;
                String name = basename(widget.selectedFile!.path);
                FileEditor newFile = FileEditor(
                  name: name,
                  language: "",
                  code: content,
                  path: widget.selectedFile!.path,
                );

                if (content != lastFileContent && !tabs.contains(newFile)) {
                  lastFileContent = content;
                  tabs.insert(0, newFile);
                }

                return CodeEditor(
                  model: EditorModel(
                    files: tabs,
                    styleOptions: EditorModelStyle(
                      heightOfContainer: constraints.maxHeight - 40,
                      widthOfContainer: constraints.maxWidth,
                      editorBorderColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                // Error occurred
                return Text('Error: ${snapshot.error}');
              } else {
                // Future is still loading
                return const CircularProgressIndicator();
              }
            },
          );
        },
      );
    }
  }
}
