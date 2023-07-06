import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path/path.dart';

import 'package:jaguar/backend/domains/entity/aspect_interface.dart';
import 'package:jaguar/components/buttons/create_project_button.dart';

import 'package:jaguar/components/output_box/output_box.dart';
import 'package:jaguar/themes/theme_switcher.dart';

import '../../backend/domains/entity/project_interface.dart';
import '../code_editor/code_editor.dart';
import '../code_editor/editor_model.dart';
import '../code_editor/editor_model_style.dart';
import '../code_editor/file_editor.dart';

class FileDetail extends StatefulWidget {
  final FileSystemEntity? selectedFile;
  final IProject? project;
  final ThemeSwitcher themeSwitcher;

  const FileDetail({
    super.key,
    this.selectedFile,
    required this.project,
    required this.themeSwitcher,
  });

  @override
  State<FileDetail> createState() => _FileDetailState();
}

class _FileDetailState extends State<FileDetail> {
  List<FileEditor> tabs = [];
  String lastFileContent = "";
  ProjectType projectType = ProjectType.nan;

  void setProjectType() {
    var aspect;
    for (aspect in widget.project!.getAspects()) {
      if (aspect.type == AspectType.maven) {
        projectType = ProjectType.java;
      }
      if (aspect.type == AspectType.tigrou) {
        projectType = ProjectType.tiger;
      }
    }
  }

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
  void initState() {
    setProjectType();
    super.initState();
  }

  Widget buildFileDetail() {
    if (widget.selectedFile == null) {
      return Container();
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
                      heightOfContainer: constraints.maxHeight - 65,
                      widthOfContainer: constraints.maxWidth,
                      editorBorderColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  projectType: projectType,
                  themeSwitcher: widget.themeSwitcher,
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildFileDetail(),
        OutputBox(
          outputText: "text",
          project: widget.project,
        ),
      ],
    );
  }
}
