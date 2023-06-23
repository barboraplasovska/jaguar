
import 'dart:io';

import 'package:pingfrontend/backend/domains/entity/feature/compiler/tigrou/tigrou_compiler.dart';
import 'package:pingfrontend/backend/domains/entity/feature/feature.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

class TigrouExecute extends Feature {


  TigrouExecute() : super(TigerFeature.exec);


  @override
  Future<ExecutionReport> execute(IProject project, {List<String> additionalArguments = const []}) async {
    TigrouCompiler.compile(project, additionalArguments: additionalArguments);
    ExecutionReport report = () => true;
    Process.run('a.out', additionalArguments);
    return report;
  }

}