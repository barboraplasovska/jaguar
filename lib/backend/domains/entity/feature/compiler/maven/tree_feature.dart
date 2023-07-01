import 'package:ping/backend/domains/entity/feature/feature.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';

import 'maven_compiler.dart';

class TreeFeature extends Feature {
  TreeFeature() : super(MavenFeature.tree);

  Future<ExecutionReport> tree(
      IProject project, List<String> additionalArguments) async {
    return await MavenCompiler.compile(project, 'dependency:tree',
        additionalArguments: additionalArguments);
  }

  @override
  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []}) async {
    return await tree(project, additionalArguments);
  }
}
