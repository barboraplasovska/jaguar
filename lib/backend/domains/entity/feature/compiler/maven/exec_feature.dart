import 'dart:io';

import 'package:ping/backend/domains/entity/feature/feature.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';
import 'package:ping/backend/domains/service/shared_prefs_handler.dart';

class ExecFeature extends Feature {
  ExecFeature() : super(MavenFeature.exec);

  static Future<void> writeOutput(String output, String rootPath) async {
    var file = File("$rootPath/.output");

    // Create the file if it doesn't exist
    if (!await file.exists()) {
      file = await file.create();
    }

    var sink = file.openWrite();
    sink.write(output);
    sink.close();
  }

  static Future<ExecutionReport> compile(IProject project, String command,
      {List<String> additionalArguments = const []}) async {
    ExecutionReport report = () => true;
    try {
      String pomPath = project.getRootNode().getPath();
      String args = await getJavaCompilationOptions();
      ProcessResult result =
          await Process.run('mvn',args.split(' '), workingDirectory: pomPath);

      await writeOutput(result.stdout, project.getRootNode().getPath());
    } catch (e) {
      report = () => false;
    }
    return report;
  }

  @override
  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []}) async {
    return await compile(project, "exec:java",
        additionalArguments: additionalArguments);
  }
}
