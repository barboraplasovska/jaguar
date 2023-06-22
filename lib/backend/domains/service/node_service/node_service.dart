import 'dart:io';
import 'package:path/path.dart';

import 'package:pingfrontend/backend/domains/entity/node/node.dart';
import 'package:pingfrontend/backend/domains/entity/node_interface.dart';
import 'package:pingfrontend/backend/domains/service/node_service_interface.dart';

class NodeService implements INodeService {
  FileSystemEntity _createFile(String path, NodeType type) {
    if (type == NodeType.folder) {
      Directory dir = Directory(path);
      dir.createSync();
      return dir;
    } else {
      File file = File(path);
      file.createSync();
      return file;
    }
  }

  @override
  INode create(INode? folder, String name, NodeType type) {
    FileSystemEntity newFile;
    String folderPath = folder?.getPath() ?? "";
    String path = join(folderPath, name);

    if (type == NodeType.file) {
      newFile = File(path);
    } else {
      newFile = Directory(path);
    }

    if (!newFile.existsSync()) {
      newFile = _createFile(path, type);
    }

    newFile = newFile.absolute;
    INode newNode = Node(newFile, type, []);

    if (type == NodeType.folder) {
      Directory dir = newFile as Directory;
      for (FileSystemEntity child in dir.listSync(recursive: false)) {
        create(newNode, basename(child.path),
            child is Directory ? NodeType.folder : NodeType.file);
      }
    }

    folder?.addChild(newNode);
    return newNode;
  }

  @override
  bool delete(INode node) {
    for (INode child in node.getChildren()) {
      delete(child);
    }

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

  NodeService();
}
