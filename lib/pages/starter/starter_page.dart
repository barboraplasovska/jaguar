import 'package:flutter/material.dart';
import 'package:ping/backend/domains/service/node_service/node_service.dart';
import 'package:ping/backend/domains/service/shared_prefs_handler.dart';
import 'package:ping/components/buttons/open_project_button.dart';
import '../../backend/domains/service/project_service/project_service.dart';
import '../../components/popups/save_tiger_path_popup.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

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
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/braises-transformed.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Welcome to our super chuper IDE.",
                  style: TextStyle(fontSize: 25)),
            ),
            OpenProjectButton(
              buttonStyle: OPButtonStyle.elevatedButton,
              pushReplacement: false,
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
