import 'dart:io';

import 'package:jaguar/backend/domains/entity/node_interface.dart';

import 'package:path/path.dart';

class Node extends INode {
  late final FileSystemEntity _file;
  late final NodeType _type;
  late INode? _parent;
  late final List<INode> _children;

  @override
  FileSystemEntity getFile() {
    return _file;
  }

  @override
  String getPath() {
    return _file.path;
  }

  String getName() {
    return basename(_file.path);
  }

  @override
  NodeType getType() {
    return _type;
  }

  Node(this._file, this._type, this._children);

  @override
  void addChild(INode node) {
    node.setParent(this);
    _children.add(node);
  }

  @override
  bool isFile() {
    return _type == NodeType.file;
  }

  @override
  bool isFolder() {
    return _type == NodeType.folder;
  }

  @override
  void removeSelfFromParent() {
    _parent!.getChildren().remove(this);
    _parent = null;
  }

  @override
  List<INode> getChildren() {
    return _children;
  }

  @override
  void setParent(INode? parent) {
    _parent = parent;
  }

  @override
  INode getParent() {
    return _parent!;
  }
}
