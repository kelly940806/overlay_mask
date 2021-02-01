import 'package:flutter/material.dart';
import 'package:overlay_mask/overlay_mask.dart';
import 'package:provider/provider.dart';

import 'notifier.dart';
import 'dart:developer';

// Demo the static overlay widget
void main() {
  runApp(MultiProvider(providers: [
    // Add the provider of self-created notifier class
    ChangeNotifierProvider(create: (context) => OnBoardingConfigNotifier()),
  ], child: HomePage()));
}

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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OverlayMaskConfig config;
  GlobalKey btnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: FlatButton(
              key: btnKey,
              child: Text('Next Page'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Page2()));
              },
            )));
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  OverlayMaskConfig config;
  GlobalKey btnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
        String hintText = 'click';

        // set the widget config and desired style of the mask
        OnBoardingConfigNotifier().setMaskConfig(OverlayMaskConfig(widgetConfig,
            hintText: hintText,
            maskColor: Colors.black.withOpacity(0.7),
            hintTextStyle: TextStyle(fontSize: 20, color: Colors.white),
            visibleBorder: Border.all(color: Colors.white, width: 2)));
      }
    });

    return Scaffold(
        body: Column(children: [
      Expanded(
          flex: 1,
          child: _buildCenterIconBtn(Icons.paste, Colors.red, () {
            showClickedDialog('Click PASTE!!');
          })),
      Expanded(
          flex: 2,
          child: _buildCenterIconBtn(Icons.clear, Colors.green, () {
            // set the overlay to invisible
            if (OnBoardingConfigNotifier().getVisible) {
              OnBoardingConfigNotifier().setVisible(false);
              showClickedDialog('Disable the Overlay Mask!!');
            } else {
              showClickedDialog('Nothing to clean!');
            }

          }, key: btnKey)),
      Expanded(
          flex: 1,
          child: _buildCenterIconBtn(Icons.copy, Colors.blue, () {
            showClickedDialog('Click COPY!!');
          })),
    ]));
  }

  Widget _buildCenterIconBtn(
      IconData iconData, Color color, VoidCallback callback,
      {key}) {
    return Container(
        alignment: Alignment.center,
        color: color,
        child: IconButton(
            icon: Icon(iconData, color: Colors.white,key: key),
            onPressed: callback));
  }

  void showClickedDialog(String titleText) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(title: Text(titleText));
        });
  }
}
