import 'package:pingfrontend/backend/domains/entity/compiler/maven/maven_compiler.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

class PackageFeature extends EntityFeature {

  Future<ExecutionReport> package(IProject project, List<String> additionalArguments) async {
    return await MavenCompiler.compile(project, 'package', additionalArguments);
  }

  @override
  Future<ExecutionReport> execute(IProject project, {List<String> additionalArguments = const []} ) async {
    return await package(project, additionalArguments);
  }

}