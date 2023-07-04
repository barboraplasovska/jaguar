import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

import 'package:ping/components/code_editor/editor_model_style.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

import 'package:ping/themes/color_highlighting/fusion_highlighting.dart';
import 'package:ping/themes/color_highlighting/java_highlighting.dart';
import 'package:ping/themes/color_highlighting/tiger_highlighting.dart';


import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/tiger.dart';
import 'package:ping/themes/theme_switcher.dart';


import '../buttons/create_project_button.dart';
import '../popups/unsaved_file_popup.dart';
import 'editor_model.dart';
import 'file_editor.dart';

class CodeEditor extends StatefulWidget {
  late final EditorModel? model;
  final ProjectType projectType;
  final ThemeSwitcher themeSwitcher;

  CodeEditor({
    Key? key,
    this.model,
    required this.projectType,
    required this.themeSwitcher,
  }) : super(key: key);

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  @override
  void initState() {
    super.initState();
  }

  CodeThemeData getCodeThemeData() {
    if (widget.themeSwitcher.currentThemeOption == AppTheme.java) {
      return CodeThemeData(styles: javaTheme);
    }
    else if (widget.themeSwitcher.currentThemeOption == AppTheme.tiger) {
      return CodeThemeData(styles: tigerTheme);
    }
    return CodeThemeData(styles: fusionTheme);
  }

  @override
  Widget build(BuildContext context) {
    EditorModel model = widget.model ??= EditorModel(files: []);

    if (model.numberOfFiles == 0) {
      return Container();
    }

    EditorModelStyle? opt = model.styleOptions;

    int? position = model.position;

    final controller = CodeController(
      text: model.allFiles[position ?? 0].code,
      language: widget.projectType == ProjectType.tiger ? tiger : java
    );

    Text showFilename(String name) {
      return Text(
        name,
        style: TextStyle(
          fontFamily: "monospace",
          letterSpacing: 1.0,
          fontWeight: FontWeight.normal,
          fontSize: opt?.fontSizeOfFilename,
          color: opt?.editorTabTextColor,
        ),
      );
    }

    Future<void> showPopUp(BuildContext context) async {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UnsavedFilePopup(
            model: model,
            position: position,
            controller: controller,
          );
        },
      );
    }

    Container buildNavbar() {
      return Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: opt?.editorColor,
          border: Border(
              bottom: BorderSide(color: opt?.editorBorderColor ?? Colors.blue)),
        ),
        child: ListView.builder(
          itemCount: model.numberOfFiles,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            final FileEditor file = model.getFileWithIndex(index);

            return Container(
              color: model.position == index
                  ? opt?.editorTabSelectedColor
                  : opt?.editorTabColor,
              child: Center(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          model.changeIndexTo(index);
                        });
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                      ),
                      child: showFilename(file.name),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if (controller.fullText !=
                            model.getCodeWithIndex(position ?? 0)) {
                          await showPopUp(context);
                        }
                        setState(() {
                          model.closeFile(file);
                        });
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 15,
                        color: opt?.editorTabTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Column(
      children: [
        buildNavbar(),
        RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (RawKeyEvent event) {
            if (event.isKeyPressed(LogicalKeyboardKey.keyS) &&
                (event.isControlPressed || event.isMetaPressed)) {
              setState(() {
                model.updateCodeOfIndex(position ?? 0, controller.fullText);
              });
            }
          },
          child: Container(
            height: opt?.heightOfContainer,
            color:
                Theme.of(context).colorScheme.primaryContainer.withAlpha(220),
            child: CodeTheme(
              data: getCodeThemeData(),
              child: SingleChildScrollView(
                child: CodeField(
                  background: Colors.transparent,
                  controller: controller,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
