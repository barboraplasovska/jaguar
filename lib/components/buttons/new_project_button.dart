import 'package:flutter/material.dart';
import 'package:jaguar/backend/domains/entity/aspect_interface.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';
import 'package:jaguar/backend/domains/service/node_service/node_service.dart';
import 'package:jaguar/backend/domains/service/project_service/project_service.dart';
import 'package:jaguar/components/buttons/open_project_button.dart';
import 'package:jaguar/pages/new_project/new_project_page.dart';
import 'package:jaguar/themes/theme_switcher.dart';

class NewProjectButton extends StatefulWidget {
  final OPButtonStyle buttonStyle;
  final bool pushReplacement;
  final ThemeSwitcher themeSwitcher;

  const NewProjectButton({
    super.key,
    required this.buttonStyle,
    required this.pushReplacement,
    required this.themeSwitcher,
  });

  @override
  State<NewProjectButton> createState() => NewProjectButtonState();
}

class NewProjectButtonState extends State<NewProjectButton> {
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
          "New project",
          style: textStyle,
        ),
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(
          "New project",
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
          if (widget.pushReplacement)
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewProjectPage(),
                ),
              )
            }
          else
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewProjectPage(),
                ),
              )
            }
          // },
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
