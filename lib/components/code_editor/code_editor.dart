import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

import 'package:pingfrontend/components/code_editor/editor_model_style.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/java.dart';

import '../popups/unsaved_file_popup.dart';
import 'editor_model.dart';
import 'file_editor.dart';

class CodeEditor extends StatefulWidget {
  late final EditorModel? model;

  CodeEditor({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late TextEditingController editingController;

  String? newValue;

  FocusNode focusNode = FocusNode();

  static final GlobalKey<FormState> editableTextKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    editingController = TextEditingController(text: "");

    newValue = "";
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  void placeCursorAtTheEnd() {
    editingController.selection = TextSelection.fromPosition(
      TextPosition(offset: editingController.text.length),
    );
  }

  void placeCursor(int pos) {
    try {
      editingController.selection = TextSelection.fromPosition(
        TextPosition(offset: pos),
      );
    } catch (e) {
      throw Exception("code_editor : placeCursor(int pos), pos is not valid.");
    }
  }

  @override
  Widget build(BuildContext context) {
    EditorModel model = widget.model ??= EditorModel(files: []);

    if (model.numberOfFiles == 0) {
      return Container();
    }

    EditorModelStyle? opt = model.styleOptions;

    int? position = model.position;

    String? code = model.getCodeWithIndex(position ?? 0);

    editingController = TextEditingController(text: code);
    newValue = code;

    final controller = CodeController(
      text: model.allFiles[position ?? 0].code,
      language: java, // FIXME: tiger ?
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
/*
    SingleChildScrollView buildEditableText() {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
            top: 10,
            bottom: 50,
          ),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: opt?.textStyleOfTextField,
            focusNode: focusNode,
            controller: editingController,
            onChanged: (String v) => newValue = v,
            key: editableTextKey,
          ),
        ),
      );
    }*/
    /*

    Widget buildContentEditor() {
      return Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: opt?.heightOfContainer,
                decoration: BoxDecoration(
                  color: opt?.editorColor.withAlpha(200),
                  border: Border(
                    bottom: BorderSide(
                      color: opt?.editorBorderColor.withOpacity(0.4) ??
                          Colors.blue.withOpacity(0.4),
                    ),
                  ),
                ),
                child: buildEditableText(),
              ),
            ],
          ),
        ],
      );
    }*/

    /* return Column(
      children: <Widget>[
        buildNavbar(),
        RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (RawKeyEvent event) {
            if (event.isKeyPressed(LogicalKeyboardKey.keyS) &&
                (event.isControlPressed || event.isMetaPressed)) {
              setState(() {
                model.updateCodeOfIndex(position ?? 0, newValue);
              });
            }
          },
          child: buildContentEditor(),
        ),
      ],
    );*/

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
              data: CodeThemeData(styles: monokaiSublimeTheme),
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
