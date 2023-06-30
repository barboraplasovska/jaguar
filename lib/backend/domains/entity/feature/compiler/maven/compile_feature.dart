import 'package:ping/backend/domains/entity/feature/feature.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';

import 'maven_compiler.dart';

class CompileFeature extends Feature {
  CompileFeature() : super(MavenFeature.compile);

  Future<ExecutionReport> compile(
      IProject project, List<String> additionalArguments) async {
    return await MavenCompiler.compile(project, 'compile',
        additionalArguments: additionalArguments);
  }

  @override
  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []}) async {
    return await compile(project, additionalArguments);
  }
}
