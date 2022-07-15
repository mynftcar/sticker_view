import 'package:flutter/cupertino.dart';
import 'package:sticker_view/resize_point.dart';

class Constants {
  static const floatingActionDiameter = 18.0;
  static const floatingActionPadding = 24.0;

  static const cursorLookup = <ResizePointType, MouseCursor>{
    ResizePointType.topLeft: SystemMouseCursors.resizeUpLeft,
    ResizePointType.topRight: SystemMouseCursors.resizeUpRight,
    ResizePointType.bottomLeft: SystemMouseCursors.resizeDownLeft,
    ResizePointType.bottomRight: SystemMouseCursors.resizeDownRight,
  };

  static const cornerDiameter = 22.0;
}