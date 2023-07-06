import 'package:jaguar/backend/domains/entity/feature/feature.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';

import 'maven_compiler.dart';

class InstallFeature extends Feature {
  InstallFeature() : super(MavenFeature.install);

  Future<ExecutionReport> install(
      IProject project, List<String> additionalArguments) async {
    return await MavenCompiler.compile(project, 'install',
        additionalArguments: additionalArguments);
  }

  @override
  Future<ExecutionReport> execute(IProject project,
      {List<String> additionalArguments = const []}) async {
    return await install(project, additionalArguments);
  }
}
