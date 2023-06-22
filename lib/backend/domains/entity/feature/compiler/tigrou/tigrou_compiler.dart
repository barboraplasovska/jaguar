import 'dart:io';

import 'package:pingfrontend/backend/domains/entity/feature/feature.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

class TigrouCompiler {

  static late String compiler;

  static void setCompiler(String compiler) {
    TigrouCompiler.compiler = compiler;
  }


  static Future<ExecutionReport> compile(IProject project, String command, {List<String> additionalArguments = const []}) async {
    ExecutionReport report = () => true;
    try {
      List<String> args = List<String>.filled(3 + additionalArguments.length, '');
      args[0] = command;
      for (int i = 0; i < additionalArguments.length; i++) {
        args[1 + i] = additionalArguments[i].toString();
      }
      ProcessResult result = await Process.run(TigrouCompiler.compiler, args);
    } catch (e) {
      report = () => false;
    }
    return report;
  }



}