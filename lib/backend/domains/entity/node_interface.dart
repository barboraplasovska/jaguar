import 'dart:io';

enum NodeType {
  file,
  folder,
}

abstract class INode {
  FileSystemEntity getFile();

  String getPath();

  NodeType getType();

  List<INode> getChildren();

  void setParent(INode? parent);

  INode getParent();

  void addChild(INode node);

  void removeSelfFromParent();

  bool isFile();

  bool isFolder();
}