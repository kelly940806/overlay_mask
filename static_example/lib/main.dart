import 'package:flutter/material.dart';
import 'package:overlay_mask/overlay_mask.dart';

// Demo the static overlay widget
void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Overlay Mask Static Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OverlayMaskConfig config;
  WidgetConfig widgetConfig;
  GlobalKey btnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use the PostFrameCallback to get the exact position and size of certain widget
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

        setState(() {
          config = OverlayMaskConfig(widgetConfig,
              hintText: hintText,
              hintColor: Colors.amber,
              hintTextStyle: TextStyle(fontSize: 20, color: Colors.white),
              visibleColor: Colors.green.withOpacity(0.5),
              hintArrowDirection: HintArrowDirection.left,
              hintTextAlign: HintTextAlign.right,
              visibleBorder: Border.all(color: Colors.red.shade700, width: 2));
        });
      }
    });

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
  }
}
