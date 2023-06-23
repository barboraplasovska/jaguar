
import 'dart:core';
import 'dart:io';

import 'package:pingfrontend/backend/domains/entity/aspect/aspect.dart';
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

  static bool _isMavenProject(String path) {
      String fullPathToPom = "$path/pom.xml";
      return File(fullPathToPom).existsSync();
  }

  Future<Set<IAspect>> _loadAspects(String path) async {
    Set<IAspect> aspects = {};

    if (_isMavenProject(path)) {
      aspects.add(Aspect(AspectType.maven));
    } else {
      aspects.add(Aspect(AspectType.tigrou));
    }

    return aspects;
  }

  @override
  IProject load(String rootPath) {
    Set<IAspect> aspects = _loadAspects(rootPath) as Set<IAspect>;

    INode rootNode = _nodeService.create(null, rootPath, NodeType.folder);

    rootNode.setParent(null);

    return Project(rootNode, aspects);
  }

  ProjectService(this._nodeService);
}