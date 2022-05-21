class Node {
  final dynamic data;
  final Node? parent;
  final List<int> children;

  Node(this.data, this.parent, this.children);
}

class Graph {
  late Map<int, Node> vertices;
  int? rootID;
  Graph.empty() {
    vertices = {};
  }
  Graph(this.vertices);

  void addNode(int? parentID, int nodeID, Node node) {
    vertices[nodeID] = node;
    vertices[parentID]?.children.add(nodeID);
  }

  Node? getNode(int nodeID) {
    return vertices[nodeID];
  }

  @override
  String toString() {
    return "<Graph | $vertices>";
  }
}
