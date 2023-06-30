import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../backend/domains/entity/project_interface.dart';
import '../../components/editor_app_bar/editor_app_bar.dart';
import '../../components/file_detail/file_detail.dart';
import '../../components/file_tree/file_provider.dart';
import '../../components/file_tree/file_tree.dart';
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: EditorAppBar(project: widget.project!),
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: 300,
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
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(themeSwitcher.currentThemePicture),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    child: FileDetail(
                      selectedFile: fileProvider.selectedFile,
                      project: widget.project,
                    ),
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
