import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hrenb/Models/Graph.dart';
import 'package:hrenb/Models/Node.dart';

import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Utils {
  static final Utils _utils = Utils._internal();
  static final firebaseStorageRef = FirebaseStorage.instance.ref();
  static final firestoreInstance = FirebaseFirestore.instance;
  static var cache = Map<String, ui.Image>();
  static var scaleFactor = 1.0;

  static const double defaultAreaSizeMultiplier = 3.5;

  static Graph? downloadedGraph = null; //TODO при выходе из графа обнулить

  factory Utils() {
    return _utils;
  }

  /* static void setScaleFactor(double screenRatio) {
    if (screenRatio > 2)
      scaleFactor = 1.4;
    else
      scaleFactor = 1;
    nodeRadius = defaultNodeRadius / scaleFactor;
    centreRadius = defaultCentreRadius / scaleFactor;
    radiusAroundCentre = defaultRadiusAroundCentre / scaleFactor;
    areaSizeMultiplier = defaultAreaSizeMultiplier / scaleFactor;
    smallButtonSize = defaultSmallButtonSize / scaleFactor;
  }*/

  Utils._internal();

  static Future<Graph> getGraph(String graphId) async {
    if (downloadedGraph == null) {
      var graphDocument =
          await firestoreInstance.collection("graphs").doc(graphId).get();
      var name = graphDocument["name"];
      var password = graphDocument["password"];
      var nodeList = List<Node>.from(json
          .decode(graphDocument["nodes"])
          .map((model) => Node.fromJson(model)));
      downloadedGraph = Graph(name, nodeList, password: password);
    }

    return Future.value(downloadedGraph);
  }

  static Future<Pair<bool, String>> saveGraph(Graph graph,
      {String? existingGraphID}) async {
    var graphID = "";
    if (existingGraphID != null)
      graphID = existingGraphID;
    else
      graphID = firestoreInstance.collection("graphs").doc().id;
    try {
      for (int i = 0; i < graph.nodes.length; i++) {
        graph.nodes[i].linkToContent =
            await saveContent(graphID, i, graph.nodes[i]);
      }
      firestoreInstance.collection("graphs").doc(graphID).set({
        "name": graph.name,
        "password": graph.password,
        "nodes": jsonEncode(graph.nodes)
      }).then((_) {
        print("success!");
      });
      return Future.value(Pair(true, graphID));
    } catch (e) {
      return Future.value(Pair(false, ""));
    }
  }

  static Future<String> saveContent(
      String graphID, int nodeId, Node node) async {
    late Reference contentRef;
    if (node.type == CONTENT_TYPE.image)
      contentRef = firebaseStorageRef
          .child("graphs")
          .child(graphID)
          .child("$nodeId.png");
    else
      contentRef = firebaseStorageRef
          .child("graphs")
          .child(graphID)
          .child("$nodeId.mp4");
    await contentRef.putData(node.content);
    return await contentRef.getDownloadURL();
  }

  /* static Future<ui.Image> convertNetworkImageToImage(String URL) async {
    if (cache.containsKey(URL)) {
      return cache[URL]!;
    } else {
      var compressedImage = await compressImage(URL);
      cache[URL] = compressedImage;
      return compressedImage;
    }
  }*/

  /*static Future<ui.Image> compressImage(String URL) async {
    if (kIsWeb) {
      //String result = await(promiseToFuture(compressImageWeb(URL,nodeRadius)));

     // result = result.split("base64,")[1];
      //var t = base64.decode(result);
     // var codec = await ui.instantiateImageCodec(t);
     // var frame = await codec.getNextFrame();
      //return frame.image;
    } else {
      print("Mobile");
      var bytes = (await http.get(Uri.parse(URL))).bodyBytes;
      return compressImageOnMobile(bytes);
    }
  }*/

  static Future<ui.Image> compressImageOnMobile(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetHeight: 100,
      targetWidth: 100,
    );
    print("compress");
    return (await codec.getNextFrame()).image;
  }
}
