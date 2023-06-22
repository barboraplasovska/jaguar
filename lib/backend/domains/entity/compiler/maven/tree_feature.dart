import 'package:pingfrontend/backend/domains/entity/compiler/maven/maven_compiler.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

class TreeFeature extends EntityFeature {

  Future<ExecutionReport> tree(IProject project, List<String> additionalArguments) async {
    return await MavenCompiler.compile(project, 'dependency:tree', additionalArguments: additionalArguments);
  }

  @override
  Future<ExecutionReport> execute(IProject project, {List<String> additionalArguments = const []} ) async {
    return await tree(project, additionalArguments);
  }

}