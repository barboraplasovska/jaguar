import 'package:flutter/material.dart';
import 'package:pingfrontend/components/file_tree/file_tree.dart';
import 'package:provider/provider.dart';

import '../../components/file_detail/file_detail.dart';
import '../../themes/theme_switcher.dart';

class CodeEditorPage extends StatefulWidget {
  const CodeEditorPage({super.key});

  @override
  State<CodeEditorPage> createState() => _CodeEditorPageState();
}

class _CodeEditorPageState extends State<CodeEditorPage> {
  @override
  Widget build(BuildContext context) {
    final themeSwitcher = Provider.of<ThemeSwitcher>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
      body: const Row(
        children: [
          Expanded(
            flex: 1,
            child: FileTree(),
          ),
          Expanded(
            flex: 9,
            child: FileDetail(),
          ),
        ],
      ),
    );
  }
}
