import 'package:flutter/material.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';
import 'package:jaguar/backend/domains/service/node_service/node_service.dart';
import 'package:jaguar/backend/domains/service/project_service/project_service.dart';
import 'package:jaguar/components/popups/add_file_popup.dart';
import 'package:provider/provider.dart';

import '../../backend/domains/entity/node_interface.dart';
import 'file_provider.dart';
import 'tree_view.dart';

class FileTree extends StatefulWidget {
  final INode root;

  const FileTree({
    super.key,
    required this.root,
  });

  @override
  State<FileTree> createState() => _FileTreeState();
}

class _FileTreeState extends State<FileTree> {
  late INode root;

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

  void updateProject() {
    setState(() {
      ProjectService projectService = ProjectService(NodeService());
      IProject project = projectService.load(root.getPath());
      root = project.getRootNode();
    });
  }

  @override
  void initState() {
    root = widget.root;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = 300;
    double calculated = calculateFileTreeWidth(widget.root, 0) + 100;
    width = width < calculated ? calculated : width;

    return Consumer<FileProvider>(
      builder: (context, fileProvider, _) {
        return ChangeNotifierProvider<FileProvider>.value(
          value: fileProvider,
          child: Stack(
            children: [
              SingleChildScrollView(
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
              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.insert_drive_file_outlined,
                        size: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddFilePopup(
                                type: FileType.file,
                                selectedFile: fileProvider.selectedFile,
                                forceUpdate: updateProject,
                              );
                            });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.create_new_folder_outlined,
                        size: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddFilePopup(
                                type: FileType.folder,
                                selectedFile: fileProvider.selectedFile,
                                forceUpdate: updateProject,
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
