import 'dart:io';

import 'package:pingfrontend/backend/domains/entity/compiler/maven/maven_compiler.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

typedef ExecutionReport = bool Function();

class ExecFeature extends EntityFeature {
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
      ProcessResult result = await Process.run('mvn', args,workingDirectory: pom_path);
    } catch (e) {
      report = () => false;
    }
    return report;
  }
}
