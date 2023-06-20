

import 'package:flutter_test/flutter_test.dart';
import 'package:pingfrontend/backend/domains/service/node_service/node_service.dart';
import 'package:pingfrontend/backend/domains/service/node_service_interface.dart';
import 'package:pingfrontend/backend/domains/service/project_service/project_service.dart';
import 'package:pingfrontend/backend/domains/service/project_service_interface.dart';

void main() {
  
  test('Test description', () {
    // Test code
    INodeService nodeService = NodeService();
    IProjectService projectService = ProjectService(nodeService);
    projectService.load("/tmp/truc");
  });

}
