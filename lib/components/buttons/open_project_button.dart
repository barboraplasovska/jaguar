import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ping/backend/domains/service/node_service/node_service.dart';
import 'package:ping/backend/domains/service/project_service/project_service.dart';

import '../../pages/code_editor/code_editor_page.dart';

enum OPButtonStyle { textButton, elevatedButton }

class OpenProjectButton extends StatefulWidget {
  final OPButtonStyle buttonStyle;
  final bool pushReplacement;

  const OpenProjectButton({
    super.key,
    required this.buttonStyle,
    required this.pushReplacement,
  });

  @override
  State<OpenProjectButton> createState() => _OpenProjectButtonState();
}

class _OpenProjectButtonState extends State<OpenProjectButton> {
  String? result;
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

  Function() buildOnPressed() {
    return () async => {
          result = await FilePicker.platform.getDirectoryPath(),
          if (result != null)
            {
              if (widget.pushReplacement)
                {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CodeEditorPage(
                        project: projectService.load(result!),
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
                        project: projectService.load(result!),
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
      child:
          buildButton(buildOnPressed(), buildButtonStyle(), buildTextStyle()),
    );
  }
}
