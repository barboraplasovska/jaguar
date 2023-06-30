import 'package:flutter/material.dart';
import 'package:ping/backend/domains/service/shared_prefs_handler.dart';

class SaveTigerPathPopup extends StatelessWidget {
  const SaveTigerPathPopup({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return AlertDialog(
      title: const Text('Save Tiger path'),
      content: Container(
        height: 200,
        child: Column(
          children: [
            const Text(
                "In order to compile Tiger, you need to provide a path to your compiler."),
            TextField(
              controller: textEditingController,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            setTigerPath(textEditingController.text);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            'Save',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
