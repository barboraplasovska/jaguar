import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ping/backend/domains/entity/aspect_interface.dart';
import 'package:ping/backend/domains/entity/feature/feature.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';
import 'package:ping/components/buttons/new_project_button.dart';
import 'package:ping/components/buttons/open_project_button.dart';
import 'package:ping/components/buttons/run_button.dart';
import 'package:ping/themes/theme_switcher.dart';
import '../buttons/settings_button.dart';

class EditorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IProject project;
  final ThemeSwitcher themeSwitcher;
  final FileSystemEntity? selectedFile;
  const EditorAppBar({
    super.key,
    required this.project,
    required this.themeSwitcher,
    required this.selectedFile,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioPlayer();

    var aspect;
    var feature;
    var path;
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
                          for (feature in aspect.getFeatures())
                            {
                              if (feature.getType() == TigerFeature.exec)
                                {
                                  path = selectedFile?.path,
                                  await feature.execute(project,
                                      additionalArguments:
                                          [path].cast<String>()),
                                }
                            }
                        }
                    },
                }),
        NewProjectButton(
            buttonStyle: OPButtonStyle.textButton,
            pushReplacement: true,
            themeSwitcher: themeSwitcher),
        OpenProjectButton(
          buttonStyle: OPButtonStyle.textButton,
          pushReplacement: true,
          themeSwitcher: themeSwitcher,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SettingsButton(),
        ),
      ],
    );
  }
}
