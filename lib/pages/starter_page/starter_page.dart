import 'package:flutter/material.dart';

import 'package:pingfrontend/backend/domains/service/node_service/node_service.dart';
import 'package:pingfrontend/pages/code_editor/code_editor_page.dart';

import 'package:file_picker/file_picker.dart';

import '../../backend/domains/service/project_service/project_service.dart';

class StarterPage extends StatelessWidget {
  const StarterPage({super.key});

  @override
  Widget build(BuildContext context) {
    NodeService nodeService = NodeService();
    ProjectService projectService = ProjectService(nodeService);
    String? result;

    return Scaffold(
      body: Center(
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Welcome to our super chuper IDE."),
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
                child: const Text("Open project"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
