import 'dart:convert';

import 'package:hrenb/Models/Node.dart';

class Graph {
  List<Node> nodes;
  String? password;
  String name;

  Graph(this.name, this.nodes, {this.password});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "password": password ,
      "nodes": jsonEncode(nodes)
    };
  }

}
