import 'package:flutter/widgets.dart';

/// This class still needs to be tested.
///
/// Need a way to scale the UI to the different sizes of screens
/// This class queries the size of the available space, which should
/// allow proper scaling of different Widgets.

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}
