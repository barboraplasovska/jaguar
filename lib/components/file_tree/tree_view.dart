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

  Widget _buildNode(INode node, {double level = 0, String? folderName}) {
    if (node.isFolder()) {
      bool isExpanded = expandedNodes.contains(node);

      List<INode> sortedChildren = List.from(node.getChildren());
      sortedChildren.sort((a, b) => a.getName().compareTo(b.getName()));

      String nodeName =
          folderName != null ? '$folderName.${node.getName()}' : node.getName();

      if (sortedChildren.length == 1 &&
          sortedChildren[0].getType() == NodeType.folder) {
        return _buildNode(sortedChildren[0],
            level: level, folderName: nodeName);
      }

      return Container(
        padding: EdgeInsets.only(left: 5 * level),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              dense: true,
              hoverColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              horizontalTitleGap: 0,
              title: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    nodeName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              onTap: () {
                toggleExpansion(node);
              },
            ),
            if (isExpanded)
              ...sortedChildren
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
      return Padding(
        padding: EdgeInsets.only(left: 5 * level),
        child: ListTile(
          dense: true,
          hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          title: Text(node.getName()),
          onTap: () {
            if (widget.onFileSelected != null) {
              widget.onFileSelected!(node.getFile());
            }
          },
        ),
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
