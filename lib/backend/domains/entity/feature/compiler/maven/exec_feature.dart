import 'dart:io';

import 'package:pingfrontend/backend/domains/entity/feature/feature.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

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
      List<String> args =
          List<String>.filled(3 + additionalArguments.length, '');
      args[0] = command;
      args[1] = '-f';
      args[2] = '${project.getRootNode().getPath()}/pom.xml';
      for (int i = 0; i < additionalArguments.length; i++) {
        args[3 + i] = additionalArguments[i].toString();
      }
      String pom_path = project.getRootNode().getPath();
      ProcessResult result =
          await Process.run('mvn', args, workingDirectory: pom_path);

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
