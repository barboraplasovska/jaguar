import 'dart:io';

enum NodeType {
  file,
  folder,
}

abstract class INode {
  File getFile();

  String getPath();

  NodeType getType();

  bool isFile() {
    return getType() == NodeType.file;
  }

  bool isFolder() {
    return getType() == NodeType.folder;
  }
}