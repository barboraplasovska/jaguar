import 'package:flutter/material.dart';

import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pingfrontend/components/file_detail/editor_model_style.dart';

import 'editor_model.dart';
import 'file_editor.dart';

class CodeEditor extends StatefulWidget {
  late final EditorModel? model;

  // ignore: prefer_const_constructors_in_immutables
  CodeEditor({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  /// We need it to control the content of the text field.
  late TextEditingController editingController;

  /// The new content of a file when the user is editing one.
  String? newValue;

  /// The text field wants a focus node.
  FocusNode focusNode = FocusNode();

  /// Initialize the formKey for the text field
  static final GlobalKey<FormState> editableTextKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    editingController = TextEditingController(text: "");

    newValue = ""; // if there are no changes
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  /// Set the cursor at the end of the editableText.
  void placeCursorAtTheEnd() {
    editingController.selection = TextSelection.fromPosition(
      TextPosition(offset: editingController.text.length),
    );
  }

  /// Place the cursor where wanted.
  ///
  /// [pos] places the cursor in the text field
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
    /// Gets the model from the parent widget.
    EditorModel model = widget.model ??= EditorModel(files: []);

    if (model.numberOfFiles == 0) {
      return Container();
    }

    /// Gets the style options from the parent widget.
    EditorModelStyle? opt = model.styleOptions;

    String? language = "dart"; //model.currentLanguage; // FIXME:

    /// Which file in the list of file ?
    int? position = model.position;

    /// The content of the file where position corresponds to the list of file.
    String? code = model.getCodeWithIndex(position ?? 0);

    // bool disableNavigationbar = widget.disableNavigationbar;

    // When we change the file in the navbar, the code in the text field
    // isn't updated, so we update it here.
    //
    // With newValue = code if the user does not change the value
    // in the text field
    editingController = TextEditingController(text: code);
    newValue = code;

    /// The filename in green.
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

    /// Build the navigation bar.
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
          //padding: const EdgeInsets.only(left: 15),
          itemCount: model.numberOfFiles,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            final FileEditor file = model.getFileWithIndex(index);

            return Container(
              //margin: const EdgeInsets.only(right: 15),
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
                      onPressed: () {
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

    /// Creates the text field.
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
            decoration: const InputDecoration(border: InputBorder.none),
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
    }

    /// Creates the edit button and the save button ("OK") with a
    /// particual function [press] to execute.
    ///
    /// This button won't appear if `edit = false`.
    Widget editButton(String name, Function() press) {
      //if (widget.edit == true) {
      return Positioned(
        bottom: opt?.editButtonPosBottom,
        right: opt?.editButtonPosRight,
        top: (model.isEditing &&
                opt != null &&
                opt.editButtonPosTop != null &&
                opt.editButtonPosTop! < 50)
            ? 50
            : opt?.editButtonPosTop,
        left: opt?.editButtonPosLeft,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: opt?.editButtonBackgroundColor,
          ),
          onPressed: press,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: "monospace",
              fontWeight: FontWeight.normal,
              color: opt?.editButtonTextColor,
            ),
          ),
        ),
      );
      /*   } else {
        return SizedBox.shrink();
      }*/
    }

    /// Add a particular string where the cursor is in the text field.
    /// * [str] the string to insert
    /// * [diff] by default, the the cursor is placed after the string placed, but you can change this (Exemple: -1 for "" placed)
    void insertIntoTextField(String str, {int diff = 0}) {
      // get the position of the cursor in the text field
      int pos = editingController.selection.baseOffset;
      // get the current text of the text field
      String baseText = editingController.text;
      // get the string : 0 -> pos of the current text and add the wanted string
      String begin = baseText.substring(0, pos) + str;
      // if we are already in the end of the string
      if (baseText.length == pos) {
        editingController.text = begin;
      } else {
        // get the end of the string and update the text of the text field
        String end = baseText.substring(pos, baseText.length);
        editingController.text = begin + end;
      }
      // if we don't do this, when we click on a toolbutton, the method
      // onChanged() isn't called, so newValue isn't updated
      newValue = editingController.text;
      placeCursor(pos + str.length + diff);
    }

    // We place the cursor in the end of the text field.

    if (model.isEditing &&
        (model.styleOptions?.placeCursorAtTheEndOnEdit ?? true)) {
      placeCursorAtTheEnd();
    }

    /// We toggle the editor and the text field.
    Widget buildContentEditor() {
      return model.isEditing
          ? Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // the toolbar
                    // toolBar(),
                    // Container of the EditableText
                    Container(
                      width: double.infinity,
                      height: opt?.heightOfContainer,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                // The OK button
                editButton("OK", () {
                  setState(() {
                    model.updateCodeOfIndex(position ?? 0, newValue);
                    model.toggleEditing();
                    //FIXME: widget.onSubmit?.call(language, newValue);
                  });
                }),
              ],
            )
          : Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: opt?.heightOfContainer,
                  color: opt?.editorColor.withAlpha(200),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: opt?.padding ?? const EdgeInsets.all(3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          HighlightView(
                            code ?? "code is null",
                            language: language,
                            theme: opt?.theme ?? githubTheme,
                            tabSize: opt?.tabSize ?? 4,
                            textStyle: TextStyle(
                              fontFamily: opt?.fontFamily,
                              letterSpacing: opt?.letterSpacing,
                              fontSize: opt?.fontSize,
                              height: opt?.lineHeight, // line-height
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                editButton(opt?.editButtonName ?? "Edit", () {
                  setState(() {
                    model.toggleEditing();
                  });
                }),
              ],
            );
    }

    return Column(
      children: <Widget>[
        buildNavbar(),
        buildContentEditor(),
      ],
    );
  }
}
