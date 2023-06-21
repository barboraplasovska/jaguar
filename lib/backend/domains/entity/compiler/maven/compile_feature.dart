import 'package:pingfrontend/backend/domains/entity/compiler/maven/maven_compiler.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

class CompileFeature extends EntityFeature {

  Future<ExecutionReport> compile(IProject project, List<String> additionalArguments) async {
    return await MavenCompiler.compile(project, 'compile', additionalArguments);
  }

  @override
  Future<ExecutionReport> execute(IProject project, {List<String> additionalArguments = const []} ) async {
    return await compile(project, additionalArguments);
  }
}