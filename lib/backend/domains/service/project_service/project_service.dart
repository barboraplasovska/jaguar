import 'dart:core';
import 'dart:io';

import 'package:jaguar/backend/domains/entity/aspect/aspect.dart';
import 'package:jaguar/backend/domains/entity/aspect_interface.dart';
import 'package:jaguar/backend/domains/entity/node_interface.dart';
import 'package:jaguar/backend/domains/entity/project/project.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';
import 'package:jaguar/backend/domains/service/node_service_interface.dart';
import 'package:jaguar/backend/domains/service/project_service_interface.dart';

class ProjectService implements IProjectService {
  late final INodeService _nodeService;

  @override
  INodeService getNodeService() {
    return _nodeService;
  }

  static bool _isMavenProject(String path) {
    String fullPathToPom = "$path/pom.xml";
    return File(fullPathToPom).existsSync();
  }

  Set<IAspect> _loadAspects(String path) {
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
    Set<IAspect> aspects = _loadAspects(rootPath);

    INode rootNode = _nodeService.create(null, rootPath, NodeType.folder);

    rootNode.setParent(null);

    return Project(rootNode, aspects);
  }

  ProjectService(this._nodeService);
}
