// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ping/backend/domains/entity/aspect_interface.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';
import 'package:ping/backend/domains/service/node_service/node_service.dart';
import 'package:ping/backend/domains/service/project_service/project_service.dart';
import 'package:ping/backend/domains/service/shared_prefs_handler.dart';
import 'package:ping/backend/utils/files/file_utils.dart';
import 'package:ping/components/popups/invalid_path_popup.dart';
import 'package:ping/themes/theme_switcher.dart';

import '../../pages/code_editor/code_editor_page.dart';

class PreviousProjectsList extends StatefulWidget {
  final ThemeSwitcher themeSwitcher;
  const PreviousProjectsList({
    super.key,
    required this.themeSwitcher,
  });

  @override
  State<PreviousProjectsList> createState() => _PreviousProjectsListState();
}

class _PreviousProjectsListState extends State<PreviousProjectsList> {
  ProjectService projectService = ProjectService(NodeService());

  List<String> filteredProjects = [];
  List<String> projects = [];
  TextEditingController searchController = TextEditingController();
  List<bool> isHovered = [];

  var iproject;

  String getProjectName(String path) {
    List<String> pathSegments = path.split('/');
    return pathSegments.isNotEmpty ? pathSegments.last : '';
  }

  Future<void> loadPreviousProjects() async {
    List<String> pr = await getPreviousProjects();
    setState(() {
      projects = pr;
      filteredProjects = projects;
      isHovered = List<bool>.filled(filteredProjects.length, false);
    });
  }

  AppTheme setProjectTheme(IProject project) {
    var aspect;
    for (aspect in project.getAspects()) {
      if (aspect.type == AspectType.maven) return AppTheme.java;
      if (aspect.type == AspectType.tigrou) return AppTheme.tiger;
    }
    return AppTheme.fusion;
  }

  @override
  void initState() {
    loadPreviousProjects();
    isHovered = List<bool>.filled(projects.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                filteredProjects = projects
                    .where((project) =>
                        project.toLowerCase().contains(value.toLowerCase()))
                    .toList();
                isHovered = List<bool>.filled(filteredProjects.length, false);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Search projects',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredProjects.length,
            itemBuilder: (context, index) {
              final path = filteredProjects[index];
              final project = getProjectName(path);
              return GestureDetector(
                onTap: () async {
                  bool directoryExists = await Directory(path).exists();
                  if (!directoryExists) {
                    removePreviousProject(path);
                    showDialog(
                        context: context,
                        builder: (context) => InvalidPathPopup(path: path));
                    return;
                  }
                  iproject = projectService.load(path);
                  widget.themeSwitcher.switchTheme(setProjectTheme(iproject));
                  await addPreviousProject(iproject.getRootNode().getPath());
                  await writeOutput("", iproject.getRootNode().getPath());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CodeEditorPage(
                        project: iproject,
                      ),
                    ),
                  );
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
                    color: isHovered[index]
                        ? Theme.of(context).colorScheme.onBackground
                        : Colors.transparent,
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          project,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            path,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(200),
                            ),
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
}
