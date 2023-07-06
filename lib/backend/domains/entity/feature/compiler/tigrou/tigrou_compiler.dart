import 'dart:io';

import 'package:jaguar/backend/domains/entity/feature/feature.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';
import 'package:jaguar/backend/domains/service/shared_prefs_handler.dart';

class TigrouCompiler {
  static late String compiler;

  static void setCompiler(String compiler) {
    TigrouCompiler.compiler = compiler;
  }

  static Future<ExecutionReport> compile(IProject project,
      {List<String> additionalArguments = const []}) async {
    ExecutionReport report = () => true;
    try {
      List<String> args = (await getTigerCompilationOptions()).split(' ');
      args.addAll(additionalArguments);
      String tigerPath = await getTigerPath();
      ProcessResult result = await Process.run(tigerPath, args);

      var rootNode = project.getRootNode().getPath();
      File outputFile = File('$rootNode/a.ll');
      await outputFile.writeAsString(result.stdout);
      args = ["-m32", "$rootNode/a.ll", "-o", "$rootNode/exec"];
      await Process.run("clang", args);
    } catch (e) {
      report = () => false;
    }
    return report;
  }
}
