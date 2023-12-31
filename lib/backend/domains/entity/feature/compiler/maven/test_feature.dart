import 'package:jaguar/backend/domains/entity/feature/feature.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';

import 'maven_compiler.dart';

class TestFeature extends Feature {
  TestFeature() : super(MavenFeature.test);

  Future<ExecutionReport> test(
      IProject project, List<String> additionalArguments) async {
    return await MavenCompiler.compile(project, 'test',
        additionalArguments: additionalArguments);
  }

  @override
  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []}) async {
    return await test(project, additionalArguments);
  }
}
