import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FileDetail extends StatelessWidget {
  final FileSystemEntity? selectedFile;

  const FileDetail({
    super.key,
    this.selectedFile,
  });

  Future<List<String>> readFile(FileSystemEntity fileEntity) async {
    // Get the FileSystemEntity representing the file path

    try {
      // Check if the entity is a file
      if (fileEntity is File) {
        // Read the lines of the file
        List<String> lines = await fileEntity.readAsLines();
        return lines;
      } else {
        return ['Error: The provided entity is not a file.'];
      }
    } catch (e) {
      return ['Error reading file:', e.toString()];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedFile == null) {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'No file',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return FutureBuilder<List<String>>(
        future: readFile(selectedFile!),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            // Lines are available
            List<String> lines = snapshot.data!;
            return ListView.builder(
              itemCount: lines.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(lines[index]),
                );
              },
            );
          } else if (snapshot.hasError) {
            // Error occurred
            return Text('Error: ${snapshot.error}');
          } else {
            // Future is still loading
            return const CircularProgressIndicator();
          }
        },
      );
    }
  }
}
