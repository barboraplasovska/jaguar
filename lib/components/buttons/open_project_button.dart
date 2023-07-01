import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ping/backend/domains/entity/aspect_interface.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';
import 'package:ping/backend/domains/service/node_service/node_service.dart';
import 'package:ping/backend/domains/service/project_service/project_service.dart';
import 'package:ping/backend/domains/service/shared_prefs_handler.dart';
import 'package:ping/themes/theme_switcher.dart';

import '../../pages/code_editor/code_editor_page.dart';

enum OPButtonStyle { textButton, elevatedButton }

class OpenProjectButton extends StatefulWidget {
  final OPButtonStyle buttonStyle;
  final bool pushReplacement;
  final ThemeSwitcher themeSwitcher;

  const OpenProjectButton({
    super.key,
    required this.buttonStyle,
    required this.pushReplacement,
    required this.themeSwitcher,
  });

  @override
  State<OpenProjectButton> createState() => _OpenProjectButtonState();
}

class _OpenProjectButtonState extends State<OpenProjectButton> {
  String? result;
  late IProject project;
  ProjectService projectService = ProjectService(NodeService());

  Widget buildButton(
      Function() onPressed, ButtonStyle buttonStyle, TextStyle textStyle) {
    if (widget.buttonStyle == OPButtonStyle.elevatedButton) {
      return ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(
          "Open project",
          style: textStyle,
        ),
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(
          "Open project",
          style: textStyle,
        ),
      );
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

  Function() buildOnPressed(BuildContext context) {
    return () async => {
          result = await FilePicker.platform.getDirectoryPath(),
          if (result != null)
            {
              project = projectService.load(result!),
              widget.themeSwitcher.switchTheme(setProjectTheme(project)),
              await addPreviousProject(project.getRootNode().getPath()),
              if (widget.pushReplacement)
                {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CodeEditorPage(
                        project: project,
                      ),
                    ),
                  )
                }
              else
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CodeEditorPage(
                        project: project,
                      ),
                    ),
                  )
                }
            },
        };
  }

  ButtonStyle buildButtonStyle() {
    if (widget.buttonStyle == OPButtonStyle.elevatedButton) {
      return ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary);
    }
    return TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  TextStyle buildTextStyle() {
    return TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: buildButton(
          buildOnPressed(context), buildButtonStyle(), buildTextStyle()),
    );
  }
}
