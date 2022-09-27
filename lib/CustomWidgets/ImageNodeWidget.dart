import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrenb/Core/SizeConfig.dart';
import 'package:hrenb/Models/Node.dart';
import 'package:video_player/video_player.dart';

import 'NodeWidget.dart';

class ImageNodeWidget extends StatefulWidget implements NodeWidget {
  Node node;
  double contentSize;
  Function animateZoomInToNode;
  var isTextVisible = false;

  NodeWidget updateWidget(NodeWidget oldWidget, bool isTextVisible,
      {bool isVideoPlaying = false}) {
    return ImageNodeWidget(node, contentSize, animateZoomInToNode,
        isTextVisible: isTextVisible);
  }

  ImageNodeWidget(this.node, this.contentSize, this.animateZoomInToNode,
      {this.isTextVisible = false, Key? key})
      : super(key: key);

  @override
  State<ImageNodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<ImageNodeWidget> {
/*
  Widget getContentWidget() {
   else if (widget.node.type == CONTENT_TYPE.video) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: VideoPlayer(_controller));
    } else
      return Container(color: Colors.deepOrangeAccent);
  }*/

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: widget.node.x,
        top: widget.node.y,
        child: Column(
          children: [
            GestureDetector(
                onTap: () {

                  widget.animateZoomInToNode(widget.node.x, widget.node.y,
                     );
                  setState(() {
                    widget.isTextVisible = true;
                  });
                },
                child: SizedBox(
                    height: widget.contentSize,
                    width: widget.contentSize,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.node.linkToContent!),
                      radius: widget.contentSize,
                    ))),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: widget.isTextVisible,
              child: SizedBox(
                  width: widget.contentSize,
                  child: Text(
                    widget.node.text ?? "",
                    textAlign: TextAlign.center,
                  )),
            )
          ],
        ));
  }
}
