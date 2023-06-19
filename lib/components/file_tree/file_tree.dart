import 'package:flutter/material.dart';

class FileTree extends StatelessWidget {
  const FileTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: const Column(
        children: [Text("File tree here")],
      ),
    );
  }
}
