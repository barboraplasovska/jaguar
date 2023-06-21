import 'package:flutter/material.dart';
import 'package:pingfrontend/backend/domains/entity/node_interface.dart';
import 'package:provider/provider.dart';

import 'file_provider.dart';
import 'tree_view.dart';

class FileTree extends StatelessWidget {
  final INode root;

  const FileTree({
    super.key,
    required this.root,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FileProvider>(
      builder: (context, fileProvider, _) {
        return ChangeNotifierProvider<FileProvider>.value(
          value: fileProvider,
          child: TreeView(
            root: root,
            onFileSelected: (file) {
              final fileProvider = Provider.of<FileProvider>(
                context,
                listen: false,
              );
              fileProvider.selectedFile = file;
            },
          ),
        );
      },
    );
  }
}
