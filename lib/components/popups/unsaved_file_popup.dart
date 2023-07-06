import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:jaguar/components/code_editor/editor_model.dart';

class UnsavedFilePopup extends StatelessWidget {
  final EditorModel model;
  final int? position;
  final CodeController controller;

  const UnsavedFilePopup(
      {super.key,
      required this.model,
      required this.position,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Unsaved file!'),
      content: Text('Do you want to save the file?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            model.updateCodeOfIndex(position ?? 0, controller.fullText);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Text(
            'Save it',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            'Close without saving',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
