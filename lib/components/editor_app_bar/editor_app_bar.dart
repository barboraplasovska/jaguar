import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pingfrontend/backend/domains/entity/aspect_interface.dart';
import 'package:pingfrontend/backend/domains/entity/feature/feature.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';
import 'package:pingfrontend/components/button/run_button.dart';
import 'package:provider/provider.dart';

import '../../backend/domains/service/node_service/node_service.dart';
import '../../backend/domains/service/project_service/project_service.dart';
import '../../pages/code_editor/code_editor_page.dart';
import '../../themes/theme_switcher.dart';

class EditorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IProject project;

  const EditorAppBar({super.key, required this.project});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeSwitcher = Provider.of<ThemeSwitcher>(context);
    final audioPlayer = AudioPlayer();

    NodeService nodeService = NodeService();
    ProjectService projectService = ProjectService(nodeService);
    String? result;

    var aspect;
    var feature;
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      actions: [
        RunButton(
            onPressed: () async => {
                  for (aspect in project.getAspects())
                    {
                      if (aspect.type == AspectType.maven)
                        {
                          audioPlayer
                              .play(AssetSource('sounds/pouring-coffee.wav')),
                          for (feature in aspect.getFeatures())
                            {
                              if (feature.getType() == MavenFeature.exec)
                                {
                                  feature.execute(project),
                                }
                            }
                        }
                      else if (aspect.type == AspectType.tigrou)
                        {
                          audioPlayer
                              .play(AssetSource('sounds/tiger_roar.wav')),
                        }
                    },
                }),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () async => {
              result = await FilePicker.platform.getDirectoryPath(),
              if (result != null)
                {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CodeEditorPage(
                        project: projectService.load(result!),
                      ),
                    ),
                  )
                },
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Open folder',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButton<AppTheme>(
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
        ),
      ],
    );
  }
}
