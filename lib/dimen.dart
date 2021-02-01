import 'dart:ui';

class AppDimen {
  static double _ratio = 1;
  static double scrWidth = 375;
  static double scrHeight = 812;
  static double safeAreaTop = 47;
  static double safeAreaBottom = 34;
  static const double _standardWidth = 375;

  static final AppDimen _appDimen = AppDimen._internal();

  factory AppDimen() {
    return _appDimen;
  }

  AppDimen._internal();

  static void setup(
      Size scrSize, double curSafeAreaTop, double curSafeAreaBottom) {
    scrWidth = scrSize.width;
    scrHeight = scrSize.height;
    _ratio = scrSize.width / _standardWidth;
    safeAreaTop = curSafeAreaTop;
    safeAreaBottom = curSafeAreaBottom;
  }

  // on boarding
  static double headlineFontSize = 18 * _ratio;
  static double hintArrowWidth = 14 * _ratio;
  static double hintArrowHeight = 8 * _ratio;
  static double hintMargin = 10 * _ratio;
  static double hintElevation = 6;
  static double hintTextRadius = 12;
  static double hintTextPaddingHeight = 8 * _ratio;
  static double hintTextPaddingWidth = 20 * _ratio;
  static double hintTextAlignArrowWidth = 24 * _ratio;
}