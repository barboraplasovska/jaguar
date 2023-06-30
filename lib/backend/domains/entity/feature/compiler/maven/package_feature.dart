import 'package:ping/backend/domains/entity/feature/feature.dart';
import 'package:ping/backend/domains/entity/project_interface.dart';

import 'maven_compiler.dart';

class PackageFeature extends Feature {
  PackageFeature() : super(MavenFeature.package);

  Future<ExecutionReport> package(
      IProject project, List<String> additionalArguments) async {
    return await MavenCompiler.compile(project, 'package',
        additionalArguments: additionalArguments);
  }

  @override
  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []}) async {
    return await package(project, additionalArguments);
  }
}
