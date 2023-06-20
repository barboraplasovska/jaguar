import 'package:pingfrontend/backend/domains/entity/node_interface.dart';

abstract class INodeService {

  /*
  * I do not know how editing the text will actually work.
  * I am keeping this as it is but further discussion may be needed */

  INode update(INode node, String content);
  bool delete(INode node);
  INode create(INode folder, String name, NodeType type);
  INode move(INode nodeToMove, INode destinationFolder);

}