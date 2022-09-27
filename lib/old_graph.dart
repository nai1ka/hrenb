/*
import 'dart:math';
import 'dart:ui' as ui;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hrenb/TransfromConfig.dart';
import 'package:hrenb/Utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:touchable/touchable.dart';
import 'package:zoom_widget/zoom_widget.dart';

late Reference storageRef;
const transitionDelta = 1;

enum AniProps { offset, scale }

class OldGraph extends StatefulWidget {
  const OldGraph({Key? key}) : super(key: key);

  @override
  State<OldGraph> createState() => _OldGraphState();
}

class _OldGraphState extends State<OldGraph>
    with TickerProviderStateMixin {

  late TimelineTween<AniProps> zoomAnimation;

  @override
  void initState() {
    super.initState();
    storageRef = FirebaseStorage.instance.ref();
    */
/* zoomAnimation = TimelineTween<AniProps>()
      ..addScene(
          begin: const Duration(milliseconds: 0),
          duration: const Duration(milliseconds: 1))
          .animate(AniProps.offset,
          tween: Tween<Offset>(begin: Offset(0,0), end: Offset(0,0)))
          .animate(AniProps.scale,
        tween: Tween<double>(begin: 1, end: 1));*//*

    zoomAnimation = TimelineTween<AniProps>()
      ..addScene(
              begin: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 500))
          .animate(AniProps.offset,
              tween: Tween<Offset>(begin: transition, end: Offset(0, 0)))
          .animate(AniProps.scale, tween: Tween<double>(begin: 1, end: 1));

    */
/*sequenceAnimation =  SequenceAnimationBuilder().addAnimatable(
    animatable: Tween<double>(
    begin: 0,
    end: 1000),
    from: Duration.zero,
    to: const Duration(milliseconds: 2000),
    curve: Curves.linear,
    tag: "width")
        .addAnimatable(
    animatable: Tween<double>(
    begin: 0,
    end: 1000),
    from: const Duration(milliseconds: 2500),
    to: const Duration(milliseconds: 5000),
    curve: Curves.linear,
    tag: "height")
    //.addAnimatable(
    //     animatable: Tween<double>(begin: min(currHeight,neededHeight), end: max(currHeight,neededHeight)),
    //     from: const Duration(milliseconds: 250),
    //   to: const Duration(milliseconds: 500),
    //    curve: Curves.ease,
    //    tag: "scale")
        .animate(controller)*//*

  }

  double zoomSize = 1;
  var transition = Offset(0, 0);

  void setZoom(double newZoomSize) {
    setState(() {
      zoomSize = newZoomSize;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  var control = CustomAnimationControl.play;

  void setTransition(Offset newTransition) {
    var currWidth = transition.dx;
    var currHeight = transition.dy;
    var neededWidth = newTransition.dx;
    var neededHeight = newTransition.dy;

    print("Click");

    zoomAnimation = TimelineTween<AniProps>()
      ..addScene(
              begin: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 500))
          .animate(AniProps.offset,
              tween: Tween<Offset>(begin: transition, end: newTransition))
          .animate(AniProps.scale, tween: Tween<double>(begin: 1, end: 5));

    setState(() {
      control = CustomAnimationControl.playFromStart;
    });
    transition = newTransition;
    */
/*while(!(currWidth==neededWidth && neededHeight==currHeight) ){
      print("$currWidth,$currHeight");
      if(currHeight<neededHeight) {
        currHeight = min(neededHeight,currHeight+transitionDelta);
      } else {
        currHeight = max(neededHeight,currHeight-transitionDelta);
      }

      if(currWidth<neededWidth) {
        currWidth = min(neededWidth,currWidth+transitionDelta);
      } else {
        currWidth = max(neededWidth,currWidth-transitionDelta);
      }*//*


    */
/*sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(
                begin: min(currWidth, neededWidth),
                end: max(currWidth, neededWidth)),
            from: Duration.zero,
            to: const Duration(milliseconds: 2000),
            curve: Curves.ease,
            tag: "width")
        .addAnimatable(
            animatable: Tween<double>(
                begin: min(currHeight, neededHeight),
                end: max(currHeight, neededHeight)),
            from: const Duration(milliseconds: 2500),
            to: const Duration(milliseconds: 5000),
            curve: Curves.ease,
            tag: "height")
        //.addAnimatable(
        //     animatable: Tween<double>(begin: min(currHeight,neededHeight), end: max(currHeight,neededHeight)),
        //     from: const Duration(milliseconds: 250),
        //   to: const Duration(milliseconds: 500),
        //    curve: Curves.ease,
        //    tag: "scale")
        .animate(controller);
   // setState(() {
    controller.forward();*//*


    //});
 // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: FutureBuilder(
                future: Utils.getListOfNodes(1, 6),
                builder: (context, AsyncSnapshot<List<Node>> snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 5000,
                          height: 5000,
                          decoration: BoxDecoration(
                            border: Border.all(width: 3.0),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(
                                    20) //                 <--- border radius here
                                ),
                          ),
                          child: CustomAnimation<TimelineValue<AniProps>>(
                              control: control,
                              startPosition: 0,
                              tween: zoomAnimation,
                              onComplete: () {
                                control = CustomAnimationControl.stop;
                              },
                              builder: (context, child, value) {
                                return CanvasTouchDetector(
                                  gesturesToOverride: const [
                                    GestureType.onTapDown
                                  ],
                                  builder: (context) => CustomPaint(
                                    willChange: true,
                                    foregroundPainter: GraphPainter(
                                        snapshot.data!,
                                        context,
                                        setZoom,
                                        setTransition,
                                        TransformConfig(
                                                value.get(AniProps.offset),
                                            value.get(AniProps.scale))),
                                  ),
                                );
                              }),
                        ),
                      ),
                    );
                  }
                  return Center(
                      child: LoadingAnimationWidget.inkDrop(
                          color: Colors.amber, size: 100));
                })));
  }
}

class GraphPainter extends CustomPainter {
  GraphPainter(this.nodeList, this.context, this.setZoom, this.setTransition,
      this.transformConfig);

  Function setZoom;
  TransformConfig transformConfig;
  Function setTransition;

  List<Node> nodeList;
  final BuildContext context;

  double angle = 0;

  @override
  void paint(Canvas canvas, Size size) {

    var scale =1.0;
    var offsetX = 0;
    var offsetY = 0;
    double nodeRadius = Utils.nodeRadius * scale;
    double centreRadius = Utils.centreRadius * scale;
    double radiusAroundCentre = Utils.radiusAroundCentre * scale;

    var myCanvas = TouchyCanvas(context, canvas);
    myCanvas.translate(100,100);
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.indigo;

    final circlesPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.amber;

    final pathPaint = Paint()
      ..color = Colors.deepOrangeAccent
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    // Draw circle in the centre
    myCanvas.drawOval(
      Rect.fromLTWH(
          size.width / 2 - centreRadius / 2 + offsetX,
          size.height / 2 - centreRadius / 2 + offsetY,
          centreRadius,
          centreRadius),
      circlesPaint,
    );

    angle = 0;
    for (var element in nodeList) {
      nodeRadius = min((element.content as ui.Image).width,
              (element.content as ui.Image).height) *
          1.0;
      var x = (radiusAroundCentre - nodeRadius / 2) * cos(angle) + offsetX;
      var y = (radiusAroundCentre - nodeRadius / 2) * sin(angle) + offsetY;
      myCanvas.drawPath(
          getPath(size.width / 2 + offsetX, size.height / 2 + offsetY,
              size.width / 2 + x, size.height / 2 + y, centreRadius),
          pathPaint);
      angle += pi / (nodeList.length / 2);
    }

    var nodesPath = Path();

    for (var element in nodeList) {
      nodeRadius = min((element.content as ui.Image).width,
              (element.content as ui.Image).height) *
          scale;
      var x = radiusAroundCentre * cos(angle) + offsetX;
      var y = radiusAroundCentre * sin(angle) + offsetY;
      nodesPath.addOval(Rect.fromLTWH(size.width / 2 + x - nodeRadius / 2,
          size.height / 2 + y - nodeRadius / 2, nodeRadius, nodeRadius));

      angle += pi / (nodeList.length / 2);
    }
    canvas.clipPath(nodesPath);

    angle = 0;
    for (var element in nodeList) {
      nodeRadius = min((element.content as ui.Image).width,
              (element.content as ui.Image).height) *
          scale;
      var x = radiusAroundCentre * cos(angle) + offsetX;
      var y = radiusAroundCentre * sin(angle) + offsetY;
      var tmpImage = element.content as ui.Image;
      double tmpZoom = 1;
      var currWidth = size.width / 2 + x - nodeRadius / 2;
      var currHeight = size.height / 2 + y - nodeRadius / 2;
      myCanvas.drawImage(
          tmpImage,
          Offset(size.width / 2 + x - nodeRadius / 2,
              size.height / 2 + y - nodeRadius / 2),
          Paint(), onTapDown: (tapDetail) {
        print(Offset(currWidth, currHeight));

        setTransition(-Offset(x, y));

        //  showCustomDialog(context);
      });

      */
/*myCanvas.drawCircle(
          Offset(size.width / 2 + x - nodeRadius / 2,
              size.height / 2 + y - nodeRadius / 2),
          nodeRadius,
          circlesPaint, onTapDown: (tapDetail) {
        print(Offset(currWidth, currHeight));

        setTransition(-Offset(x, y));
      });*//*


      angle += pi / (nodeList.length / 2);
    }
    //myCanvas.scale(2);

    // Draw path
  }

  RRect getBorder(double margin, Size size) {
    return RRect.fromRectAndRadius(
        Rect.fromLTWH(
            margin, margin, size.width - margin * 2, size.height - margin * 2),
        const Radius.circular(20));
  }

  Path getPath(double x_from, double y_from, double x_to, double y_to,
      double centreRadius) {
    var path = Path()
      ..moveTo(x_from, y_from)
      ..lineTo(x_to, y_to);

    Path dashPath = Path();

    double dashWidth = 10.0;
    double dashSpace = 10.0;
    double distance = centreRadius / 2;

    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
    return dashPath;
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) => true;
}

*/
/*
List<Node> generateNodesList() {
  return [
    Node(1, CONTENT_TYPE.audio),
    Node(2, CONTENT_TYPE.audio),
    Node(3, CONTENT_TYPE.audio),
    Node(4, CONTENT_TYPE.audio),
    Node(5, CONTENT_TYPE.audio),
    Node(6, CONTENT_TYPE.audio),
    Node(7, CONTENT_TYPE.audio),
    Node(8, CONTENT_TYPE.audio),
    Node(9, CONTENT_TYPE.audio),
    Node(10, CONTENT_TYPE.audio),
    Node(11, CONTENT_TYPE.audio),
    Node(12, CONTENT_TYPE.audio),
  ];
}
*//*


List<String> getListOfLinksToImages(int id, int numOfImages) {
  List<String> result = [];
  for (int i = 1; i <= numOfImages; i++) {
    result.add(storageRef.child("graphs/$id/$i").fullPath);
  }
  return result;
}

void showCustomDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          child: Container(
            height: 300.0,
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Cool',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Awesome',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 50.0)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Got It!',
                      style: TextStyle(color: Colors.purple, fontSize: 18.0),
                    ))
              ],
            ),
          ),
        );
      });
}
*/
