import 'dart:io';

import 'package:flutter/material.dart';

import '../../backend/domains/entity/node_interface.dart';

class TreeView extends StatefulWidget {
  final INode root;
  final void Function(FileSystemEntity file)? onFileSelected;

  const TreeView({
    Key? key,
    required this.root,
    required this.onFileSelected,
  }) : super(key: key);

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  List<INode> expandedNodes = [];

  void toggleExpansion(INode node) {
    setState(() {
      if (expandedNodes.contains(node)) {
        expandedNodes.remove(node);
      } else {
        expandedNodes.add(node);
      }
    });
  }

  Widget _buildNode(INode node, {double level = 0}) {
    if (node.isFolder()) {
      bool isExpanded = expandedNodes.contains(node);

      return Container(
        padding: EdgeInsets.only(left: 20 * level),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              dense: true,
              hoverColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              horizontalTitleGap: 0,
              contentPadding: const EdgeInsets.only(left: 10),
              leading: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                node.getPath(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onTap: () {
                toggleExpansion(node);
              },
            ),
            if (isExpanded)
              ...node
                  .getChildren()
                  .map(
                    (child) => _buildNode(
                      child,
                      level: level + 1,
                    ),
                  )
                  .toList(),
          ],
        ),
      );
    } else {
      return ListTile(
        dense: true,
        hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        title: Text(node.getPath()),
        onTap: () {
          if (widget.onFileSelected != null) {
            // FIXME: possibly pass the path of the parent + file  ?
            widget.onFileSelected!(node.getFile());
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildNode(widget.root),
      ],
    );
  }
}
