import 'dart:io';

import 'package:flutter/material.dart';

import '../../backend/domains/entity/project_interface.dart';

class OutputBox extends StatefulWidget {
  final String outputText;
  final IProject? project;

  const OutputBox({
    super.key,
    required this.outputText,
    required this.project,
  });

  @override
  State<OutputBox> createState() => _OutputBoxState();
}

class _OutputBoxState extends State<OutputBox> {
  String outputText = "";

  Future<String> readFile(String path) async {
    var file = File(path);
    if (await file.exists()) {
      return file.readAsString();
    } else {
      return "";
    }
  }

  FutureBuilder<String> buildOutputText(String rootPath) {
    String path = "$rootPath/.output";
    return FutureBuilder(
      future: readFile(path),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!);
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        initialChildSize: 0.03,
        minChildSize: 0.03,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OUTPUT",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  buildOutputText(widget.project!.getRootNode().getPath()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
