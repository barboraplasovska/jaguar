import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';
import 'package:pingfrontend/components/file_tree/file_tree.dart';
import 'package:provider/provider.dart';

import '../../backend/domains/entity/node/node.dart';
import '../../backend/domains/entity/node_interface.dart';
import '../../components/editor_app_bar/editor_app_bar.dart';
import '../../components/file_detail/file_detail.dart';
import '../../components/file_tree/file_provider.dart';
import '../../themes/theme_switcher.dart';

class CodeEditorPage extends StatefulWidget {
  final IProject? project;
  const CodeEditorPage({
    super.key,
    required this.project,
  });

  @override
  State<CodeEditorPage> createState() => _CodeEditorPageState();
}

class _CodeEditorPageState extends State<CodeEditorPage> {
  // FIXME-begin: hardcoded for file-tree
  /*final INode root = Node(
    File('Folder 2'),
    NodeType.folder,
    [
      Node(File('File 3'), NodeType.file, []),
      Node(
        File('Subfolder'),
        NodeType.folder,
        [
          Node(File('File 4'), NodeType.file, []),
        ],
      ),
    ],
  );*/
  // FIXME-end:

  @override
  Widget build(BuildContext context) {
    final themeSwitcher = Provider.of<ThemeSwitcher>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FileProvider>(create: (_) => FileProvider()),
        ChangeNotifierProvider<ThemeSwitcher>.value(
          value: themeSwitcher,
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const EditorAppBar(),
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: FileTree(
                  root: widget.project!.getRootNode(),
                ),
              ),
            ),
            Consumer<FileProvider>(
              builder: (context, fileProvider, _) {
                return Expanded(
                  flex: 8,
                  child: FileDetail(
                    selectedFile: fileProvider.selectedFile,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
