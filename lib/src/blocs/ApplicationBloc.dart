import 'dart:async';

import 'package:insightq/src/blocs/BlocProvider.dart';
import 'package:insightq/src/models/InsightQState.dart';
import 'package:insightq/src/models/ScreenInfo.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc implements BlocBase {

  Stream<InsightQState> get state => _state.stream.distinct();
  final _state = BehaviorSubject.seeded(new InsightQState()
  );

  void dispose(){
    _state.close();
  }

  void setMediaData(ScreenInfo screenInfo)
  {
    _state.value.screenInfo.statsPlatformHeaderHeight = 90 / screenInfo.devicePixelRatio;
    _state.value.screenInfo.orientation = screenInfo.orientation;
    _state.value.screenInfo.screenWidth = screenInfo.screenWidth;
    _state.value.screenInfo.screenHeight = screenInfo.screenHeight;

    _state.value.screenInfo.appBarHeight = screenInfo.appBarHeight;

    _state.value.screenInfo.blockSizeHorizontal = screenInfo.screenWidth / 100;
    _state.value.screenInfo.blockSizeVertical = screenInfo.screenHeight / 100;

  }

}
