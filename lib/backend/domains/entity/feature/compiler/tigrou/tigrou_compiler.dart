import 'dart:io';

import 'package:ping/backend/domains/entity/feature/feature.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';

class TigrouCompiler {
  static late String compiler;

  static void setCompiler(String compiler) {
    TigrouCompiler.compiler = compiler;
  }

  static Future<ExecutionReport> compile(IProject project,
      {List<String> additionalArguments = const []}) async {
    ExecutionReport report = () => true;
    try {
      List<String> args =
          List<String>.filled(3 + additionalArguments.length, '');
      args[0] = "-ac";
      args[1] = "--llvm-runtime-display";
      args[2] = "--llvm-display";
      for (int i = 0; i < additionalArguments.length; i++) {
        args[3 + i] = additionalArguments[i].toString();
      }

      ProcessResult result = await Process.run(compiler, args);
      var rootNode = project.getRootNode().getPath();
      File outputFile = File('$rootNode/a.ll');
      await outputFile.writeAsString(result.stdout);
      args = ["-m32","$rootNode/a.ll","-o","$rootNode/exec"];
      await Process.run("clang", args);
    } catch (e) {
      report = () => false;
    }
    return report;
  }
}
