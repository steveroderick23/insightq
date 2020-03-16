import 'package:flutter/material.dart';

import 'screen_info.dart';

class InsightQState {
  ScreenInfo screenInfo = new ScreenInfo(Orientation.landscape, 200.0, 200.0, 1.0, 30.0);
  String selectedTeamUid;
  String selectedGameUid;

  InsightQState();
}
