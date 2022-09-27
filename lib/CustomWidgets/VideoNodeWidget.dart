import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrenb/CustomWidgets/NodeWidget.dart';
import 'package:hrenb/Models/Node.dart';
import 'package:video_player/video_player.dart';

class VideoNodeWidget extends StatefulWidget implements NodeWidget {
  Node node;
  double contentSize;
  Function animateZoomInToNode;
  var isTextVisible = false;
  var isVideoPlaying = false;

  NodeWidget updateWidget(NodeWidget oldWidget, bool isTextVisible,
      {bool isVideoPlaying = false}) {
    return VideoNodeWidget(
      node,
      contentSize,
      animateZoomInToNode,
      isTextVisible: isTextVisible,
      isVideoPlaying: isVideoPlaying,
    );
  }

  VideoNodeWidget(this.node, this.contentSize, this.animateZoomInToNode,
      {this.isTextVisible = false, this.isVideoPlaying = false, Key? key})
      : super(key: key);

  @override
  State<VideoNodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<VideoNodeWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      widget.node.linkToContent!,
    );
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVideoPlaying) {
      _controller.pause();
    }
    else{
      _controller.play();
    }
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Positioned(
              left: widget.node.x,
              top: widget.node.y,
              child: Column(
                children: [
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: ()  {
                         widget.animateZoomInToNode(widget.node.x, widget.node.y,
                            );
                        setState(() {
                          widget.isVideoPlaying = !widget.isVideoPlaying;
                          widget.isTextVisible = true;
                        });
                      },
                      child: IgnorePointer(
                        child: SizedBox(
                            height: widget.contentSize,
                            width: widget.contentSize,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: VideoPlayer(_controller))),
                      )),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: widget.isTextVisible,
                    child: SizedBox(
                        width: widget.contentSize + 60,
                        child: Text(
                          widget.node.text ?? "",
                          textAlign: TextAlign.center,
                        )),
                  )
                ],
              ));
        } else {
          return  Center(
            child: Positioned(
                left: widget.node.x,
                top: widget.node.y,
                child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
