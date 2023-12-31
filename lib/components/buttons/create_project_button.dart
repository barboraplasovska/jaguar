import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jaguar/backend/domains/entity/aspect_interface.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';
import 'package:jaguar/backend/domains/service/node_service/node_service.dart';
import 'package:jaguar/backend/domains/service/project_service/project_service.dart';
import 'package:jaguar/backend/domains/service/shared_prefs_handler.dart';
import 'package:jaguar/backend/utils/files/file_utils.dart';
import 'package:jaguar/pages/code_editor/code_editor_page.dart';
import 'package:jaguar/themes/theme_switcher.dart';

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
    final comDirectory = Directory('$path/src/main/java/');
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
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>$projectName</artifactId>
    <version>1.0.0</version>
    
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    
    <build>
        <plugins>
            <!-- ... Existing plugins ... -->
            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>exec-maven-plugin</artifactId>
                <version>3.1.0</version>
                <configuration>
                    <mainClass>Main</mainClass>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
''');
  }

  void addTigerSpecificCode(String path) {
    // Create main.tig file for Tiger project
    final mainFile = File('$path/main.tig');
    mainFile.writeAsStringSync('print("Hello, World!")');
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
        await writeOutput("", iproject.getRootNode().getPath()),
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
