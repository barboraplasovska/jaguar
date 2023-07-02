import 'dart:io';

import 'package:ping/backend/domains/entity/feature/compiler/tigrou/tigrou_compiler.dart';
import 'package:ping/backend/domains/entity/feature/feature.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';

class TigrouExecute extends Feature {
  TigrouExecute() : super(TigerFeature.exec);
  static Future<void> writeOutput(String output, String rootPath) async {
    var file = File("$rootPath/.output");

    if (!await file.exists()) {
      file = await file.create();
    }

    var sink = file.openWrite();
    sink.write(output);
    sink.close();
  }

  @override
  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []}) async {
    var rootpath = project.getRootNode().getPath();
    var file = File("$rootpath/a.ll");
    if (! await file.exists()) {
      await TigrouCompiler.compile(project, additionalArguments: additionalArguments);
    }
    ExecutionReport report = () => true;
    var process = await Process.run("$rootpath/exec", []);

    await writeOutput(process.stdout, rootpath);
    await file.delete();
    return report;
  }
}
