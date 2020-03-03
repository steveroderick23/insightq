import 'package:flutter/material.dart';

class ScreenInfo {

  ScreenInfo(this.orientation, this.screenWidth, this.screenHeight, this.devicePixelRatio, this.appBarHeight);

  double screenWidth;
  double screenHeight;
  Orientation orientation;
  double appBarHeight;
  double statsPlatformHeaderHeight;
  double devicePixelRatio;

  double blockSizeHorizontal;
  double blockSizeVertical;

}
