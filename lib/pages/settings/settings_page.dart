import 'package:flutter/material.dart';
import 'package:ping/backend/domains/service/shared_prefs_handler.dart';
import 'package:ping/themes/theme_switcher.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isEditing = false;
  TextEditingController pathController = TextEditingController();

  Future<void> loadTigerPath() async {
    String path = await getTigerPath();
    setState(() {
      pathController.text = path;
    });
  }

  @override
  void initState() {
    loadTigerPath();
    super.initState();
  }

  @override
  void dispose() {
    pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeSwitcher = Provider.of<ThemeSwitcher>(context);
    final focusNode = FocusNode();

    void toggleEdit() {
      setState(() {
        if (isEditing) {
          setTigerPath(pathController.text);
        }
        isEditing = !isEditing;
        if (!isEditing) {
          // pathController.clear();
          FocusScope.of(context).unfocus();
          focusNode.requestFocus();
        }
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    splashRadius: 20,
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                const Text(
                  "Settings",
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  "App theme",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8.0),
                DropdownButton<AppTheme>(
                  value: themeSwitcher.currentThemeOption,
                  onChanged: (AppTheme? theme) {
                    if (theme != null) {
                      themeSwitcher.switchTheme(theme);
                    }
                  },
                  items: AppTheme.values.map((theme) {
                    return DropdownMenuItem<AppTheme>(
                      value: theme,
                      child: Text(theme.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  'Tiger path',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 400,
                  child: TextField(
                    focusNode: focusNode,
                    enabled: isEditing,
                    controller: pathController,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: toggleEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                  child: Text(
                    isEditing ? 'Save' : 'Edit',
                    style: TextStyle(
                        color: isEditing
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onTertiary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
