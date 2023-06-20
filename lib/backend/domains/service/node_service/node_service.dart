import 'dart:io';
import 'package:path/path.dart';

import 'package:pingfrontend/backend/domains/entity/node/node.dart';
import 'package:pingfrontend/backend/domains/entity/node_interface.dart';
import 'package:pingfrontend/backend/domains/service/node_service_interface.dart';

class NodeService implements INodeService {
  @override
  INode create(INode folder, String name, NodeType type) {
    FileSystemEntity newFile;
    if (type == NodeType.file) {
      newFile = File(folder.getPath() + name);
    } else {
      newFile = Directory(folder.getPath() + name);
    }

    INode newNode = Node(newFile, type, {});
    folder.addChild(newNode);
    return newNode;
  }

  @override
  bool delete(INode node) {
    FileSystemEntity file = node.getFile();
    node.removeSelfFromParent();
    file.deleteSync(recursive: true);
    return true;
  }

  @override
  INode move(INode nodeToMove, INode destinationFolder) {
    nodeToMove.getFile().renameSync(
        destinationFolder.getPath() + basename(nodeToMove.getPath()));
    INode newNode = create(destinationFolder, basename(nodeToMove.getPath()),
        nodeToMove.getType());
    delete(nodeToMove);

    destinationFolder.addChild(newNode);
    return nodeToMove;
  }

  @override
  INode update(INode node, String content) {
    return node;
  }
}
