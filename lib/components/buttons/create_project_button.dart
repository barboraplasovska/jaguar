import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ping/backend/domains/entity/aspect_interface.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';
import 'package:ping/backend/domains/service/node_service/node_service.dart';
import 'package:ping/backend/domains/service/project_service/project_service.dart';
import 'package:ping/backend/domains/service/shared_prefs_handler.dart';
import 'package:ping/pages/code_editor/code_editor_page.dart';
import 'package:ping/themes/theme_switcher.dart';

enum ProjectType { java, tiger, nan }

class CreateProjectButton extends StatefulWidget {
  final String name;
  final String path;
  final ProjectType type;
  final ThemeSwitcher themeSwitcher;
  const CreateProjectButton({
    super.key,
    required this.name,
    required this.path,
    required this.type,
    required this.themeSwitcher,
  });

  @override
  State<CreateProjectButton> createState() => _CreateProjectButtonState();
}

class _CreateProjectButtonState extends State<CreateProjectButton> {
  ProjectService projectService = ProjectService(NodeService());
  var result;
  late IProject iproject;

  void createProject(String name, String path, ProjectType type) {
    // FIXME: add different stuff depending on project type
    final projectDirectory = Directory('$path/$name');
    projectDirectory.create(recursive: true);
  }

  AppTheme setProjectTheme(IProject project) {
    var aspect;
    for (aspect in project.getAspects()) {
      if (aspect.type == AspectType.maven) return AppTheme.java;
      if (aspect.type == AspectType.tigrou) return AppTheme.tiger;
    }
    return AppTheme.fusion;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async => {
        // create project
        createProject(
          widget.name,
          widget.path,
          widget.type,
        ),
        // open new project
        result = "${widget.path}/${widget.name}",
        iproject = projectService.load(result),
        widget.themeSwitcher.switchTheme(setProjectTheme(iproject)),
        await addPreviousProject(iproject.getRootNode().getPath()),
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CodeEditorPage(
              project: iproject,
            ),
          ),
        ),
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        "Create",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: 16,
        ),
      ),
    );
  }
}
