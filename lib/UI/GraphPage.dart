import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hrenb/Core/SizeConfig.dart';
import 'package:hrenb/CustomWidgets/NodeWidget.dart';
import 'package:hrenb/Models/Graph.dart';
import 'package:hrenb/Models/Node.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:simple_animations/simple_animations.dart';

import '../CustomWidgets/ImageNodeWidget.dart';
import '../CustomWidgets/VideoNodeWidget.dart';
import '../Utils.dart';

var isFirstStart = true;

double minZoom = 1 / SizeConfig.areaSizeMultiplier;

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  GraphPageState createState() => GraphPageState();
}

class GraphPageState extends State<GraphPage> with AnimationMixin {
  late AnimationController zoomInController;
  late AnimationController zoomOutController;

  var isInteractiveViewEnabled = true;
  List<Widget>? nodesWidgetList = null;
  var isZoomOutFabIsVisible = false;
  final TransformationController transformationController =
      TransformationController();

  List<Widget> getGraphWidget(
    Graph graph,
  ) {
    List<Widget> res = [];
    if (nodesWidgetList == null) {
      for (var node in graph.nodes) {
        if (node.type == CONTENT_TYPE.image)
          res.add(ImageNodeWidget(
              node, SizeConfig.nodeRadius, animateZoomInToNode));
        else if (node.type == CONTENT_TYPE.video)
          res.add(VideoNodeWidget(
              node, SizeConfig.nodeRadius, animateZoomInToNode));
      }

      nodesWidgetList = res;
    }
    return nodesWidgetList!;
  }

  @override
  void initState() {
    print("Graph initState");
    super.initState();
    zoomInController = createController();
    zoomOutController = createController();
    transformationController.value = Matrix4Transform().scale(minZoom, origin: Offset(1000,1000)).matrix4;
  }

  void animateZoomOutToGraph(double scale) {
    for (int i = 0; i < nodesWidgetList!.length; i++) {
      var element = nodesWidgetList![i] as NodeWidget;
      nodesWidgetList![i] = element.updateWidget(element, false, isVideoPlaying: false);
    }
    var prevTransformationControllerValue = transformationController.value;
    zoomOutController.reset();
    var zoomOutAnimation = Matrix4Tween(
            begin: prevTransformationControllerValue,
            end: Matrix4Transform().scale(scale).matrix4)
        .animate(zoomOutController);
    zoomOutAnimation.addListener(() {
      transformationController.value = zoomOutAnimation.value;
      if (!zoomOutController.isAnimating) {
        setState(() {
          isZoomOutFabIsVisible = false;
          isInteractiveViewEnabled = true;
        });
      }
    });

    zoomOutController.play(duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    zoomOutController.dispose();
    zoomInController.dispose();
    transformationController.dispose();
  }

  void animateZoomInToNode(
      double x, double y) async {
    setState(() {
      isInteractiveViewEnabled = false;
    });
    var prevTransformationControllerValue = transformationController.value;
    zoomInController.reset();
    var zoomInAnimation = Matrix4Tween(
            begin: prevTransformationControllerValue,
            end: Matrix4Transform()
                .translate(
                    x: -x -SizeConfig.areaBorderWidth - SizeConfig.nodeRadius/2 + SizeConfig.screenWidth/2,
                    y: -y  - SizeConfig.areaBorderWidth -  SizeConfig.nodeRadius/2 + SizeConfig.screenHeight/2)
                .scale(1.5,
                    origin: Offset(x + SizeConfig.nodeRadius / 2 + SizeConfig.areaBorderWidth, y + SizeConfig.nodeRadius / 2 + SizeConfig.areaBorderWidth))
                .matrix4)
        .animate(zoomInController);
    zoomInAnimation.addListener(() {
      transformationController.value = zoomInAnimation.value;
      if (!zoomInController.isAnimating) {
        setState(() {
          isZoomOutFabIsVisible = true;
        });
      }
    });

    zoomInController.play(duration: const Duration(milliseconds: 500));
  }

  final number = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final graphID = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
        child: Scaffold(
            body: FutureBuilder(
                future: Utils.getGraph(graphID),
                builder: (context, AsyncSnapshot<Graph> snapshot) {
                  if (snapshot.hasData) {
                    return InteractiveViewer(
                      panEnabled: isInteractiveViewEnabled,
                      scaleEnabled: isInteractiveViewEnabled,
                      boundaryMargin: EdgeInsets.all(512),
                      transformationController: transformationController,
                      maxScale: 3,
                      minScale: minZoom,
                      constrained: false,
                      child: Container(
                        width: SizeConfig.areaWidth,
                        height: SizeConfig.areaHeight,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: SizeConfig.areaBorderWidth),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Stack(children: getGraphWidget(snapshot.data!)),
                      ),
                    );
                  }
                  return Center(
                      child: LoadingAnimationWidget.inkDrop(
                          color: Colors.black, size: 100));
                }),
            floatingActionButton: Visibility(
              visible: isZoomOutFabIsVisible,
              child: Container(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  child: Icon(Icons.zoom_out, size: 40),
                  onPressed: () {
                    setState(() {
                      isZoomOutFabIsVisible = false;
                    });
                    animateZoomOutToGraph(minZoom);
                  },
                ),
              ),
            )));
  }
}
