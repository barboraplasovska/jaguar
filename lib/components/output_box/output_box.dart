import 'dart:async';
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
  late File _outputFile;
  late StreamSubscription<FileSystemEvent> _fileSubscription;

  @override
  void initState() {
    super.initState();
    setupFileMonitoring();
  }

  void setupFileMonitoring() async {
    String filePath = "${widget.project!.getRootNode().getPath()}/.ping/output";
    _outputFile = File(filePath);

    if (await _outputFile.exists()) {
      updateOutputText();
    }

    _fileSubscription = _outputFile.parent.watch().listen((event) {
      if (event.path == _outputFile.path) {
        updateOutputText();
      }
    });
  }

  Future<void> updateOutputText() async {
    try {
      String newOutputText = await _outputFile.readAsString();
      setState(() {
        outputText = newOutputText;
      });
    } catch (e) {
      setState(() {
        outputText = '';
      });
    }
  }

  @override
  void dispose() {
    _fileSubscription.cancel();
    super.dispose();
  }

  Future<String> readFile(String path) async {
    var file = File(path);
    if (await file.exists()) {
      return file.readAsString();
    } else {
      return "";
    }
  }

  RichText buildOutputText() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.white),
        children: <TextSpan>[
          TextSpan(
            // text: outputText,
            style: const TextStyle(color: Colors.white),
            children: _getTextSpans(outputText),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _getTextSpans(String text) {
    const infoPattern = r'^\[INFO\].*$';
    const errorPattern = r'^\[ERROR\].*$';
    const debugPattern = r'^\[DEBUG\].*$';
    const warningPattern = r'^\[WARNING\].*$';

    final lines = text.split('\n');
    final spans = <TextSpan>[];

    for (var line in lines) {
      if (RegExp(infoPattern).hasMatch(line)) {
        spans.add(TextSpan(
            text: '$line\n', style: const TextStyle(color: Colors.blue)));
      } else if (RegExp(errorPattern).hasMatch(line)) {
        spans.add(TextSpan(
            text: '$line\n', style: const TextStyle(color: Colors.red)));
      } else if (RegExp(debugPattern).hasMatch(line)) {
        spans.add(TextSpan(
            text: '$line\n', style: const TextStyle(color: Colors.grey)));
      } else if (RegExp(warningPattern).hasMatch(line)) {
        spans.add(TextSpan(
            text: '$line\n', style: const TextStyle(color: Colors.orange)));
      } else {
        spans.add(TextSpan(text: '$line\n'));
      }
    }

    return spans;
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "OUTPUT",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  buildOutputText(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
