import 'dart:io';

import 'package:ping/backend/domains/entity/feature/feature.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';
import 'package:ping/backend/domains/service/shared_prefs_handler.dart';
import 'package:ping/backend/utils/files/file_utils.dart';

class ExecFeature extends Feature {
  ExecFeature() : super(MavenFeature.exec);

  static Future<ExecutionReport> compile(IProject project, String command,
      {List<String> additionalArguments = const []}) async {
    await writeOutput("", project.getRootNode().getPath());
    ExecutionReport report = () => true;
    try {
      String pomPath = project.getRootNode().getPath();
      String args = await getJavaCompilationOptions();
      args = "${args != "" ? "$command$args" : command} -q";
      List<String> arguments= args.split(' ');
      await Process.run('mvn', ['clean','install'], workingDirectory: pomPath);
      ProcessResult result =
          await Process.run('mvn', arguments, workingDirectory: pomPath);
      String stringWithoutEscapeSequences = result.stdout.replaceAll(RegExp(r'\x1B\[[0-9;]*[mG]'), '');
      await writeOutput(stringWithoutEscapeSequences, project.getRootNode().getPath());
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
