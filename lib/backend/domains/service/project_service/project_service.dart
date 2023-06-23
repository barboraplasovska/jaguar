
import 'package:pingfrontend/backend/domains/entity/aspect_interface.dart';
import 'package:pingfrontend/backend/domains/entity/node_interface.dart';
import 'package:pingfrontend/backend/domains/entity/project/project.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';
import 'package:pingfrontend/backend/domains/service/node_service_interface.dart';
import 'package:pingfrontend/backend/domains/service/project_service_interface.dart';

class  ProjectService implements IProjectService {

  late final INodeService _nodeService;

  @override
  INodeService getNodeService() {
    return _nodeService;
  }

  @override
  IProject load(String rootPath) {
    Set<IAspect> aspects = {};

    INode rootNode = _nodeService.create(null, rootPath, NodeType.folder);

    rootNode.setParent(null);

    return Project(rootNode, aspects);
  }

  ProjectService(this._nodeService);
}