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
  bool isEditingTigerPath = false;
  TextEditingController tigerPathController = TextEditingController();

  bool isEditingJavaOptions = false;
  TextEditingController javaOptionsController = TextEditingController();

  bool isEditingTigerOptions = false;
  TextEditingController tigerOptionsController = TextEditingController();

  Future<void> loadTigerPath() async {
    String path = await getTigerPath();
    setState(() {
      tigerPathController.text = path;
    });
  }

  Future<void> loadTigerOptions() async {
    String res = await getTigerCompilationOptions();
    setState(() {
      tigerOptionsController.text = res;
    });
  }

  Future<void> loadJavaOptions() async {
    String res = await getJavaCompilationOptions();
    setState(() {
      javaOptionsController.text = res;
    });
  }

  @override
  void initState() {
    loadTigerPath();
    loadTigerOptions();
    loadJavaOptions();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildEditableTextField(String title, bool isEditing,
      TextEditingController controller, Function() toggleEdit) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Text(
            title,
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
              enabled: isEditing,
              controller: controller,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeSwitcher = Provider.of<ThemeSwitcher>(context);

    void toggleEditTigerPath() {
      setState(() {
        if (isEditingTigerPath) {
          setTigerPath(tigerPathController.text);
        }
        isEditingTigerPath = !isEditingTigerPath;
        if (!isEditingTigerPath) {
          FocusScope.of(context).unfocus();
        }
      });
    }

    void toggleEditTigerOptions() {
      setState(() {
        if (isEditingTigerOptions) {
          setTigerCompilationOptions(tigerOptionsController.text);
        }
        isEditingTigerOptions = !isEditingTigerOptions;
        if (!isEditingTigerOptions) {
          FocusScope.of(context).unfocus();
        }
      });
    }

    void toggleEditJavaOptions() {
      setState(() {
        if (isEditingJavaOptions) {
          setJavaCompilationOptions(javaOptionsController.text);
        }
        isEditingJavaOptions = !isEditingJavaOptions;
        if (!isEditingJavaOptions) {
          FocusScope.of(context).unfocus();
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
          buildEditableTextField(
            "Tiger path",
            isEditingTigerPath,
            tigerPathController,
            toggleEditTigerPath,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Compilation options",
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          buildEditableTextField(
            "Tiger",
            isEditingTigerOptions,
            tigerOptionsController,
            toggleEditTigerOptions,
          ),
          buildEditableTextField(
            "Java",
            isEditingJavaOptions,
            javaOptionsController,
            toggleEditJavaOptions,
          ),
        ],
      ),
    );
  }
}
