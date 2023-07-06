import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jaguar/backend/utils/path/path_utils.dart';
import 'package:jaguar/components/buttons/create_project_button.dart';
import 'package:jaguar/themes/theme_switcher.dart';
import 'package:provider/provider.dart';

class NewProjectPage extends StatefulWidget {
  const NewProjectPage({super.key});

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  int selectedIndex = 0; // Track the selected index
  List<bool> isHovered = [];
  List<String> options = ["New project", "Empty project"];

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isJavaSelected = true;

  String name = "";
  String path = "";

  var result;

  Widget buildEditableTextField(
      String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 30,
              child: TextField(
                enabled: title != "Location:",
                controller: controller,
                onChanged: (value) => {
                  setState(() {
                    if (title == "Location:") {
                      path = value;
                    } else {
                      name = value;
                    }
                  })
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          ElevatedButton(
            onPressed: title == "Location:"
                ? () async => {
                      result = await FilePicker.platform.getDirectoryPath(
                          initialDirectory:
                              controller.text != "" ? controller.text : null),
                      if (result != null)
                        {
                          setState(() {
                            path = result;
                            controller.text = getAbsolutePath(result);
                          })
                        }
                    }
                : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                disabledBackgroundColor: Colors.transparent),
            child: Text(
              "Browse",
              style: TextStyle(
                color: title == "Location:"
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Colors.transparent,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildLanguageSelector() {
    final textStyle = TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "Language:",
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF787879),
                width: 0.5,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isJavaSelected = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isJavaSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primaryContainer,
                    shadowColor: Colors.transparent,
                    side: const BorderSide(
                      color: Color(0xFF787879),
                      width: 0.5,
                      style: BorderStyle.none,
                    ),
                  ),
                  child: Text(
                    "Java",
                    style: textStyle,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isJavaSelected = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isJavaSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primaryContainer,
                    shadowColor: Colors.transparent,
                    side: const BorderSide(
                      color: Color(0xFF787879),
                      width: 0.5,
                      style: BorderStyle.none,
                    ),
                  ),
                  child: Text(
                    "Tiger",
                    style: textStyle,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildNewProject(ThemeSwitcher themeSwitcher) {
    return Stack(
      children: [
        Column(
          children: [
            buildEditableTextField("Name:", nameController),
            buildEditableTextField("Location:", locationController),
            buildLanguageSelector(),
          ],
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: CreateProjectButton(
            name: name,
            path: path,
            type: isJavaSelected ? ProjectType.java : ProjectType.tiger,
            themeSwitcher: themeSwitcher,
          ),
        ),
      ],
    );
  }

  Widget buildEmptyProject(ThemeSwitcher themeSwitcher) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "A basic project that allows working with separate files and compiling Java and Tiger classes.",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF787879),
              ),
            ),
            buildEditableTextField("Name:", nameController),
            buildEditableTextField("Location:", locationController),
          ],
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: CreateProjectButton(
            name: name,
            path: path,
            type: ProjectType.nan,
            themeSwitcher: themeSwitcher,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    isHovered = List<bool>.filled(options.length, false);
    super.initState();
  }

  Widget buildProjectTypeList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index; // Update the selected index
                  });
                },
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHovered[index] = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHovered[index] = false;
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    color: selectedIndex == index
                        ? Theme.of(context).colorScheme.primary.withAlpha(200)
                        : isHovered[index]
                            ? Theme.of(context).colorScheme.onBackground
                            : Colors.transparent,
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          options[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: selectedIndex == index
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selectedIndex == index
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildNewProjectPage(ThemeSwitcher themeSwitcher) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Container(
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: buildProjectTypeList(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    padding: const EdgeInsets.all(20),
                    child: selectedIndex == 0
                        ? buildNewProject(themeSwitcher)
                        : buildEmptyProject(themeSwitcher),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeSwitcher = Provider.of<ThemeSwitcher>(context);
    return buildNewProjectPage(themeSwitcher);
  }
}
