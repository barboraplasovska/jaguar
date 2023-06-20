import 'package:pingfrontend/backend/domains/entity/project_interface.dart';
import 'package:pingfrontend/backend/domains/service/node_service_interface.dart';

abstract class IProjectService {
  IProject load(String rootPath);

  INodeService getNodeService();
}