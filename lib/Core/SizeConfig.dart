import 'dart:math';

import 'package:flutter/widgets.dart';

class SizeConfig {
  static final SizeConfig _utils = SizeConfig._internal();

  factory SizeConfig() {
    return _utils;
  }

  SizeConfig._internal();

  static late Size screenSize;
  static late double screenWidth;
  static late double screenHeight;
  static late double areaWidth;
  static late double areaHeight;

  static const double areaBorderWidth = 10;

  static const double nodeRadius = 250;
  static const double radiusAroundCentre = 500;
  static const double areaSizeMultiplier = 4;
  static const double smallButtonSize = 80;

  /*static double nodeRadius = defaultNodeRadius;
  static double radiusAroundCentre = defaultRadiusAroundCentre;
  static double areaSizeMultiplier = defaultAreaSizeMultiplier;
  static double smallButtonSize = defaultSmallButtonSize;*/

  static void init(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;

    areaWidth = min(screenWidth, screenHeight) * areaSizeMultiplier;
    areaHeight =  min(screenWidth, screenHeight) * areaSizeMultiplier;
    //  nodeRadius = min(safeBlockHorizontal,safeBlockVertical)*10;
    //radiusAroundCentre = min(safeBlockHorizontal,safeBlockVertical)*20;
    //smallButtonSize = min(safeBlockHorizontal,safeBlockVertical)*3.25;
  }
}
