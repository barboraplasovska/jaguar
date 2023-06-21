import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pingfrontend/backend/domains/entity/node_interface.dart';

class TreeViewState extends ChangeNotifier {
  INode? _root;

  INode? get root => _root;

  set root(INode? value) {
    _root = value;
    notifyListeners();
  }
}

class TreeView extends StatelessWidget {
  final INode root;
  final void Function(FileSystemEntity file)? onFileSelected;

  const TreeView({
    Key? key,
    required this.root,
    required this.onFileSelected,
  }) : super(key: key);

  Widget _buildNode(INode node, {double level = 0}) {
    if (node.isFolder()) {
      return Padding(
        padding: EdgeInsets.only(left: 20 * level),
        child: ExpansionTile(
          title: Text(node.getPath()),
          children: node
              .getChildren()
              .map((child) => _buildNode(child, level: level + 1))
              .toList(),
        ),
      );
    } else {
      return ListTile(
        title: Text(node.getPath()),
        onTap: () {
          // FIXME: open file in editor
          if (onFileSelected != null) {
            onFileSelected!(node.getFile());
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildNode(root),
      ],
    );
  }
}
