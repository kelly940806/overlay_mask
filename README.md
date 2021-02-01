# overlay_mask

A package that can provide the overlay mask on top of the another widget. You can set one visible/touchable area on the overlay mask, this area will not be masked and it still can pass the event to the lower widget. You can also set the hint dialog on the overlay mask as an instruction for users.

The package can be used both statically or dynamically. The common usage for this package is the onboarding page.

## Usage
There are two examples for the usage of this package. In example project, I demonstrate how to use it statically. In example2, I show the way to use it dynamically with provider and consumer.

**Installation**
Add the package to pubspec.yaml
```dart
dependencies:
  overlay_mask: ^0.0.1
```
Import it to your project
```dart
import 'package:overlay_mask/overlay_mask.dart';
```

The attributes we can set in the OverlayMaskConfig are listed below:
The most important part is the visibleWidgetConfig, that is the only area that you can touch to trigger the lower widget.
```dart
OverlayMaskConfig(this.visibleWidgetConfig,
      {this.hintText,
        this.hintArrowDirection = HintArrowDirection.down,
        this.hintTextAlign = HintTextAlign.center,
        this.hintColor = Colors.deepPurple,
        this.hintTextStyle,
        this.maskColor = Colors.black26,
        this.visibleColor = Colors.transparent,
        this.visibleBorder});
```

**Static Example**
Set the OverlayMaskConfig
```dart
 config = OverlayMaskConfig(widgetConfig,
              hintText: hintText,
              hintColor: Colors.amber,
              hintTextStyle: TextStyle(fontSize: 20, color: Colors.white),
              visibleColor: Colors.green.withOpacity(0.5),
              hintArrowDirection: HintArrowDirection.left,
              hintTextAlign: HintTextAlign.right,
              visibleBorder: Border.all(color: Colors.red.shade700, width: 2));
```

Add the stack widget and put the OverlayMaskWidget on top of the widget that you want to mask.
```dart
return Scaffold(
        // Just add the OverlayMaskWidget in the top of the stack
        body: Stack(children: [
      Container(
          color: Colors.white,
          child: Container(
              alignment: Alignment.center,
              child: FlatButton(
                key: btnKey,
                child: Text('Click'),
                onPressed: () {
                  print('Click!');
                },
              ))),
      OverlayMaskWidget(config)
    ]));
```
The demo look like this:
[![static_example_demo](https://github.com/kelly940806/overlay_mask/blob/master/static_example/assets/static_example.png "static_example_demo")](https://github.com/kelly940806/overlay_mask/blob/master/static_example/assets/static_example.png "static_example_demo")

**Dynamic Example**
It is an example for dynamically change the overlay mask. It is a common usage for onboarding intruction.
First, make your own singelton ChangeNotifier class that extend OverlayMaskConfigNotifier class. You can add other attribute to control the changes.
```dart
class OnBoardingConfigNotifier extends OverlayMaskConfigNotifier {
  static final OnBoardingConfigNotifier _onBoardingConfig =
      OnBoardingConfigNotifier._internal();

  factory OnBoardingConfigNotifier() {
    return _onBoardingConfig;
  }

  OnBoardingConfigNotifier._internal();
}
```
Then, add the provider
```dart
void main() {
  runApp(MultiProvider(providers: [
    // Add the provider of self-created notifier class
    ChangeNotifierProvider(create: (context) => OnBoardingConfigNotifier()),
  ], child: HomePage()));
}
```

Next, add the stack, and wrap the OverlayMaskWidget with consumer and put it on top of the MaterialApp.
```dart
class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Just add the OverlayMaskWidget in the top of the stack to keep it on top of every page
    return MaterialApp(
        title: 'Overlay Mask Dynamic Demo',
        debugShowCheckedModeBanner: false,
        home: Stack(
      children: [
        MaterialApp(
          title: 'Overlay Mask Dynamic Demo',
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        ),
        // Add the consumer to receive and apply the changes of Singleton OverlayMaskConfig
        Consumer<OnBoardingConfigNotifier>(builder: (context, notifier, child) {
          // return Container(child:Text('123'));
          return OverlayMaskWidget(notifier.getMaskConfig);
        })
      ],
    ));
  }
}

```

Last, just change the config at your desired moment and it works.
```dart
// Use the PostFrameCallback to get the exact position and size of certain widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (config == null &&
          btnKey != null &&
          btnKey.currentContext != null &&
          btnKey.currentContext.findRenderObject() != null) {
        RenderBox renderBox = btnKey.currentContext.findRenderObject();
        Offset position = renderBox.localToGlobal(Offset.zero);

        // Set widget config
        WidgetConfig widgetConfig = WidgetConfig(
            Size(renderBox.size.width, renderBox.size.height),
            Offset(position.dx, position.dy));

        // Set the hint text
        String hintText = 'hint';

        OnBoardingConfigNotifier().setMaskConfig(OverlayMaskConfig(widgetConfig,
            hintText: hintText,
            hintColor: Colors.amber,
            hintTextStyle: TextStyle(fontSize: 20, color: Colors.white),
            visibleColor: Colors.green.withOpacity(0.5),
            hintArrowDirection: HintArrowDirection.left,
            hintTextAlign: HintTextAlign.right,
            visibleBorder: Border.all(color: Colors.red.shade700, width: 2)));
      }
    });
```
The demo look like this:
[![dynamic_example_demo_1](https://github.com/kelly940806/overlay_mask/blob/master/dynamic_example/assets/dynamic_example_1.png "dynamic_example_demo_1")](https://github.com/kelly940806/overlay_mask/blob/master/dynamic_example/assets/dynamic_example_1.png "dynamic_example_demo_1")
[![dynamic_example_demo_2](https://github.com/kelly940806/overlay_mask/blob/master/dynamic_example/assets/dynamic_example_2.png "dynamic_example_demo_2")](https://github.com/kelly940806/overlay_mask/blob/master/dynamic_example/assets/dynamic_example_2.png "dynamic_example_demo_2")
[![dynamic_example_demo_3](https://github.com/kelly940806/overlay_mask/blob/master/dynamic_example/assets/dynamic_example_3.png "dynamic_example_demo_3")](https://github.com/kelly940806/overlay_mask/blob/master/dynamic_example/assets/dynamic_example_3.png "dynamic_example_demo_3")


## See More
You can get the source code in [github](https://github.com/kelly940806/overlay_mask "github")



