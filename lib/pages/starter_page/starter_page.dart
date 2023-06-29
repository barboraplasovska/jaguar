import 'package:flutter/material.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';
import 'package:pingfrontend/backend/domains/service/node_service/node_service.dart';
import 'package:pingfrontend/pages/code_editor/code_editor_page.dart';
import 'package:provider/provider.dart';

import 'package:file_picker/file_picker.dart';

import '../../backend/domains/service/project_service/project_service.dart';
import '../../themes/theme_switcher.dart';

class StarterPage extends StatelessWidget {
  const StarterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeSwitcher = Provider.of<ThemeSwitcher>(context);
    NodeService nodeService = NodeService();
    ProjectService projectService = ProjectService(nodeService);
    String? result;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
         decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/braises-transformed.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Welcome to our super chuper IDE.",
              style: TextStyle(fontSize: 25)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () async => {
                  result = await FilePicker.platform.getDirectoryPath(),
                  if (result != null)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CodeEditorPage(
                            project: projectService.load(result!),
                          ),
                        ),
                      )
                    },
                },
                 style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary),
                child: const Text(
                  "Open project",
                  style: TextStyle(fontSize: 25),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
