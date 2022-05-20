class Node {
  final dynamic data;
  final Node? parent;
  final List<Node> children;

  Node(this.data, this.parent, this.children);
}

class Graph {
  late Map<int, Node> vertices;
  Graph.empty() {
    vertices = {};
  }
  Graph(this.vertices);

  void addNode(int? parentID, int nodeID, Node node) {
    vertices[nodeID] = node;
    vertices[parentID]?.children.add(node);
  }

  Node? getNode(int nodeID) {
    return vertices[nodeID];
  }
}
