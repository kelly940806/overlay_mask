import 'package:overlay_mask/overlay_mask.dart';


// Make own singleton class that extends to the OverlayMaskConfigNotifier
// Perhaps you can add more config to change the state
class OnBoardingConfigNotifier extends OverlayMaskConfigNotifier {
  static final OnBoardingConfigNotifier _onBoardingConfig =
      OnBoardingConfigNotifier._internal();

  factory OnBoardingConfigNotifier() {
    return _onBoardingConfig;
  }

  OnBoardingConfigNotifier._internal();
}
