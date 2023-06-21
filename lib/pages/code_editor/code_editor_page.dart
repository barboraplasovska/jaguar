import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pingfrontend/components/file_tree/file_tree.dart';
import 'package:provider/provider.dart';

import '../../backend/domains/entity/node/node.dart';
import '../../backend/domains/entity/node_interface.dart';
import '../../components/file_detail/file_detail.dart';
import '../../components/file_tree/file_provider.dart';
import '../../themes/theme_switcher.dart';

class CodeEditorPage extends StatefulWidget {
  const CodeEditorPage({super.key});

  @override
  State<CodeEditorPage> createState() => _CodeEditorPageState();
}

class _CodeEditorPageState extends State<CodeEditorPage> {
  // FIXME-begin: hardcoded for file-tree
  final INode root = Node(
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
  );
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<AppTheme>(
                value: themeSwitcher.currentThemeOption,
                onChanged: (AppTheme? theme) {
                  if (theme != null) {
                    setState(() {
                      themeSwitcher.switchTheme(theme);
                    });
                  }
                },
                items: AppTheme.values.map((theme) {
                  return DropdownMenuItem<AppTheme>(
                    value: theme,
                    child: Text(theme.toString().split('.').last),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: FileTree(
                root: root,
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
