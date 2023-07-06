import 'package:jaguar/backend/domains/entity/node_interface.dart';

import 'aspect_interface.dart';

abstract class IProject {
  INode getRootNode();
  Set<IAspect> getAspects();
}
