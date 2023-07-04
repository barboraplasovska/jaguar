import 'dart:io';

import 'package:ping/backend/domains/entity/feature/compiler/tigrou/tigrou_compiler.dart';
import 'package:ping/backend/domains/entity/feature/feature.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';
import 'package:ping/backend/utils/files/file_utils.dart';

class TigrouExecute extends Feature {
  TigrouExecute() : super(TigerFeature.exec);

  @override
  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []}) async {
    await writeOutput("", project.getRootNode().getPath());
    var rootpath = project.getRootNode().getPath();
    var file = File("$rootpath/a.ll");
    if (!await file.exists()) {
      await TigrouCompiler.compile(project,
          additionalArguments: additionalArguments);
    }
    ExecutionReport report = () => true;
    var process = await Process.run("$rootpath/exec", []);

    await writeOutput(process.stdout, rootpath);
    if (await file.exists()) {
      await file.delete();
    }
    return report;
  }
}
