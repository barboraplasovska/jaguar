import 'package:pingfrontend/backend/domains/entity/feature/compiler/tigrou/tigrou_compiler.dart';
import 'package:pingfrontend/backend/domains/entity/feature/feature.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

class TigrouCompile extends Feature {
  
  TigrouCompile(): super(TigerFeature.compile);
  
  @override
  Future<ExecutionReport> execute(IProject project, {List<String> additionalArguments = const []}) async => TigrouCompiler.compile(project, additionalArguments: additionalArguments);
  
}