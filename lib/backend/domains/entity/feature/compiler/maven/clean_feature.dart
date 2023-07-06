import 'package:jaguar/backend/domains/entity/feature/feature.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';

import 'maven_compiler.dart';

class CleanFeature extends Feature {
  CleanFeature() : super(MavenFeature.clean);

  Future<ExecutionReport> clean(
      IProject project, List<String> additionalArguments) async {
    return await MavenCompiler.compile(project, 'clean',
        additionalArguments: additionalArguments);
  }

  @override
  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []}) async {
    return await clean(project, additionalArguments);
  }
}
