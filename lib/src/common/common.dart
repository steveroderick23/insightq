import 'package:flutter/material.dart';
import 'package:insightq/src/models/screen_info.dart';

const Map<String, String> formTypes = {"PRWE": "PRWE - Patient-Rated Wrist Evaluation"};

typedef void BuildContextCallback(String routeName);

enum DialogActions {
  cancel,
  discard,
  disagree,
  agree,
}

int calculateCrossAxisCount(ScreenInfo screenInfo) {
  int count = (screenInfo.screenWidth / 400).floor();
  return count == 0 ? 1 : count;
}

double calculateStaggeredGridScaleMultiplier(MediaQueryData media) {
  if (media.orientation == Orientation.landscape)
    return media.size.width / 100;
  else
    return media.size.height / 100;
}

double calculateVerticalScaleMultiplier(MediaQueryData media) {
  if (media.orientation == Orientation.landscape)
    return media.size.height / 100;
  else
    return media.size.width / 100;
}

double calculateHorizontalScaleMultiplier(MediaQueryData media) {
  if (media.orientation == Orientation.landscape)
    return media.size.width / 100;
  else
    return media.size.height / 100;
}

double calculateBlockSizeVertical(MediaQueryData media) {
  return media.size.height / 100;
}

double calculateBlockSizeHorizontal(MediaQueryData media) {
  return media.size.width / 100;
}

double calculateTextScaleMultiplier(MediaQueryData media) {
  if (media.orientation == Orientation.landscape)
    return media.size.height / 100;
  else
    return media.size.width / 100;
}
