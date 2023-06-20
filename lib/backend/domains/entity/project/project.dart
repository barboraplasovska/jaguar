import 'package:pingfrontend/backend/domains/entity/aspect_interface.dart';
import 'package:pingfrontend/backend/domains/entity/node_interface.dart';
import 'package:pingfrontend/backend/domains/entity/project_interface.dart';

class Project implements IProject {

  late final INode _rootNode;
  late final Set<IAspect> _aspects;

  @override
  Set<IAspect> getAspects() {
    return _aspects;
  }

  @override
  INode getRootNode() {
    return _rootNode;
  }

  Project(this._rootNode, this._aspects);
}