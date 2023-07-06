import 'package:flutter_test/flutter_test.dart';
import 'package:jaguar/backend/domains/entity/node_interface.dart';
import 'package:jaguar/backend/domains/entity/project_interface.dart';
import 'package:jaguar/backend/domains/service/node_service/node_service.dart';
import 'package:jaguar/backend/domains/service/node_service_interface.dart';
import 'package:jaguar/backend/domains/service/project_service/project_service.dart';
import 'package:jaguar/backend/domains/service/project_service_interface.dart';

void main() {
  test('Test description', () {
    // Test code
    INodeService nodeService = NodeService();
    IProjectService projectService = ProjectService(nodeService);
    IProject project = projectService.load("/tmp/truc/");
    for (INode node in project.getRootNode().getChildren()) {
      print(node.getPath());
    }
  });
}
