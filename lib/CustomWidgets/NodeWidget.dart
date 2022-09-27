import 'package:flutter/material.dart';

abstract class NodeWidget extends StatefulWidget {
  NodeWidget updateWidget(NodeWidget oldWidget, bool isTextVisible, {bool isVideoPlaying = false});
  // $videoState
  // true - play, false - stop
}