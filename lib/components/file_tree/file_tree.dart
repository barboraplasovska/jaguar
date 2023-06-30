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

  double calculateFileTreeWidth(INode node, double level) {
    double totalWidth = 0;

    if (node.isFolder()) {
      List<INode> sortedChildren = List.from(node.getChildren());
      sortedChildren.sort((a, b) => a.getName().compareTo(b.getName()));

      if (sortedChildren.isNotEmpty) {
        INode lastChild = sortedChildren.last;
        totalWidth += calculateFileTreeWidth(lastChild, level + 1) + 25;
      }

      totalWidth += sortedChildren.length * 25;
    } else {
      double textWidth = getTextWidth(node.getName());
      totalWidth += textWidth;
    }

    return totalWidth;
  }

  double getTextWidth(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    return textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    double width = 300;
    double calculated = calculateFileTreeWidth(root, 0) + 100;
    width = width < calculated ? calculated : width;

    return Consumer<FileProvider>(
      builder: (context, fileProvider, _) {
        return ChangeNotifierProvider<FileProvider>.value(
          value: fileProvider,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
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
            ),
          ),
        );
      },
    );
  }
}
