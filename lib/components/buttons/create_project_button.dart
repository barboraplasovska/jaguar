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

  void addJavaSpecificCode(String path, String projectName) {
    // create /com/example
    final comDirectory = Directory('$path/com/example');
    comDirectory.createSync(recursive: true);

    // Create Main.java file
    final mainFile = File('${comDirectory.path}/Main.java');
    mainFile.writeAsStringSync('''
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
''');

// Create pom.xml file
    final pomFile = File('$path/pom.xml');
    pomFile.writeAsStringSync('''
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>$projectName</artifactId>
    <version>1.0.0</version>
</project>
''');
  }

  void addTigerSpecificCode(String path) {
    // Create main.tig file for Tiger project
    final mainFile = File('$path/main.tig');
    mainFile.writeAsStringSync('print("Hello, World!");');
  }

  void createProject(String name, String path, ProjectType type) {
    final projectDirectory = Directory('$path/$name');
    projectDirectory.createSync(recursive: true);
    if (type == ProjectType.java) {
      addJavaSpecificCode(projectDirectory.path, name);
    } else if (type == ProjectType.tiger) {
      addTigerSpecificCode(projectDirectory.path);
    }
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
