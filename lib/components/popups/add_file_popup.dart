import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ping/backend/utils/path/path_utils.dart';

enum FileType { file, folder }

class AddFilePopup extends StatefulWidget {
  final FileType type;
  final FileSystemEntity? selectedFile;
  final Function forceUpdate;
  const AddFilePopup({
    super.key,
    required this.type,
    required this.selectedFile,
    required this.forceUpdate,
  });

  @override
  State<AddFilePopup> createState() => _AddFilePopupState();
}

class _AddFilePopupState extends State<AddFilePopup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String location = "";
  String name = "";
  var result;

  void createFile(String name, String path) {
    if (widget.type == FileType.file) {
      File file = File('$path/$name');
      file.createSync();
      widget.forceUpdate();
    } else {
      Directory directory = Directory('$path/$name');
      directory.createSync();
      widget.forceUpdate();
    }
  }

  Widget buildEditableTextField(
      String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 30,
              child: TextField(
                enabled: title != "Location:",
                controller: controller,
                onChanged: (value) => {
                  setState(() {
                    if (title == "Location:") {
                      location = value;
                    } else {
                      name = value;
                    }
                  })
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          ElevatedButton(
            onPressed: title == "Location:"
                ? () async => {
                      result = await FilePicker.platform.getDirectoryPath(
                          initialDirectory: controller.text != ""
                              ? controller.text
                              : widget.selectedFile != null
                                  ? widget.selectedFile!.path
                                  : ""),
                      if (result != null)
                        {
                          setState(() {
                            location = result;
                            controller.text = getAbsolutePath(result);
                          })
                        }
                    }
                : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                disabledBackgroundColor: Colors.transparent),
            child: Text(
              "Browse",
              style: TextStyle(
                color: title == "Location:"
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Colors.transparent,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 500,
        height: 220,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.type == FileType.file
                    ? "Create a file"
                    : "Create a folder",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildEditableTextField("Name:", nameController),
            buildEditableTextField("Location:", locationController),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        createFile(name, location);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text("OK"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
