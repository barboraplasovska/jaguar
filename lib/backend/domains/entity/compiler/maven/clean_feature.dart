import 'package:pingfrontend/backend/domains/entity/compiler/maven/maven_compiler.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

class CleanFeature extends EntityFeature {

  Future<ExecutionReport> clean(IProject project, List<String> additionalArguments) async {
    return await MavenCompiler.compile(project, 'clean', additionalArguments: additionalArguments);
  }

  @override
  Future<ExecutionReport> execute(IProject project, {List<String> additionalArguments = const []} ) async {
    return await clean(project, additionalArguments);
  }

}