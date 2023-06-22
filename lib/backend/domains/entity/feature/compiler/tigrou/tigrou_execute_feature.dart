
import 'package:pingfrontend/backend/domains/entity/feature/feature.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

class TigrouExecute extends Feature {


  TigrouExecute() : super(TigerFeature.exec);


  @override
  Future<ExecutionReport> execute(IProject project, {List<String> additionalArguments = const []}) {
    // TODO: implement execute
    throw UnimplementedError();
  }

}