import 'package:flutter/material.dart';
import 'package:ping/backend/domains/service/node_service/node_service.dart';
import 'package:ping/backend/domains/service/shared_prefs_handler.dart';
import 'package:ping/components/buttons/new_project_button.dart';
import 'package:ping/components/buttons/open_project_button.dart';
import 'package:ping/components/buttons/settings_button.dart';
import 'package:ping/components/previous_projects_list/previous_projects_list.dart';
import 'package:ping/themes/theme_switcher.dart';
import '../../backend/domains/service/project_service/project_service.dart';
import '../../components/popups/save_tiger_path_popup.dart';

class StarterPage extends StatefulWidget {
  final ThemeSwitcher themeSwitcher;
  const StarterPage({
    super.key,
    required this.themeSwitcher,
  });

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  ProjectService projectService = ProjectService(NodeService());
  String? result;

  late Future<String> path;

  @override
  void initState() {
    path = getTigerPath();
    super.initState();
  }

  Widget buildStarterPage() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                color: Theme.of(context).colorScheme.background,
                child: const Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage("assets/images/fusion.png"),
                                height: 100,
                              ),
                              Text(
                                "PING",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("Welcome to the best Java / Tiger IDE."),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 1,
                      left: 1,
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SettingsButton()),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.only(top: 10),
                child: Stack(
                  children: [
                    PreviousProjectsList(
                      themeSwitcher: widget.themeSwitcher,
                    ),
                    Positioned(
                      right: 1,
                      top: 4,
                      child: Row(
                        children: [
                          NewProjectButton(
                              buttonStyle: OPButtonStyle.elevatedButton,
                              pushReplacement: false,
                              themeSwitcher: widget.themeSwitcher),
                          OpenProjectButton(
                            buttonStyle: OPButtonStyle.elevatedButton,
                            pushReplacement: false,
                            themeSwitcher: widget.themeSwitcher,
                          ),
                        ],
                      ),
                    ),
                  ],
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
    return FutureBuilder<String>(
      future: path,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData &&
            (snapshot.data == null || snapshot.data == "")) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const SaveTigerPathPopup();
              },
            );
          });
        }
        return buildStarterPage();
      },
    );
  }
}
