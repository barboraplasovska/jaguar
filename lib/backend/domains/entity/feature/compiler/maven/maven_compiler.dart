import 'dart:io';
import 'package:jaguar/backend/domains/entity/feature/feature.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';

class MavenCompiler {
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
      ProcessResult result = await Process.run('mvn', args);
    } catch (e) {
      report = () => false;
    }
    return report;
  }
}
