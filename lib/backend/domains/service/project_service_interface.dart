import '../entity/project_interface.dart';
import 'node_service_interface.dart';

abstract class IProjectService {
  IProject load(String rootPath);

  INodeService getNodeService();
}
