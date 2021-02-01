library overlay_mask;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:overlay_mask/dimen.dart';

import 'dart:ui' as ui;
import 'dart:io' show Platform;

// Store the config of widget
class WidgetConfig {
  Size size;
  Offset position;
  Offset offset;

  WidgetConfig(this.size, this.position, {this.offset = Offset.zero});
}

enum HintArrowDirection { left, top, right, down }
enum HintTextAlign { center, left, right }

// Create your own singleton class that extend this class
class OverlayMaskConfigNotifier extends ChangeNotifier {
  OverlayMaskConfig _maskConfig;

  bool get getVisible => this._maskConfig != null;

  void setVisible(bool show) {
    // clear the widget
    this._maskConfig = null;
    notifyListeners();
  }

  OverlayMaskConfig get getMaskConfig => _maskConfig;

  void setMaskConfig(OverlayMaskConfig maskConfig) {
    this._maskConfig = maskConfig;
    notifyListeners();
  }
}

class OverlayMaskConfig {
  OverlayMaskConfig(this.visibleWidgetConfig,
      {this.hintText,
        this.hintArrowDirection = HintArrowDirection.down,
        this.hintTextAlign = HintTextAlign.center,
        this.hintColor = Colors.deepPurple,
        this.hintTextStyle,
        this.maskColor = Colors.black26,
        this.visibleColor = Colors.transparent,
        this.visibleBorder});

  // The config to store the visible area
  WidgetConfig visibleWidgetConfig;

  // optional attribute
  String hintText;
  HintArrowDirection hintArrowDirection;
  HintTextAlign hintTextAlign;
  Color hintColor;
  TextStyle hintTextStyle;
  Color maskColor;
  Color visibleColor;
  Border visibleBorder;

  WidgetConfig get getVisibleWidgetConfig => visibleWidgetConfig;

  String get getHitText => hintText;

  HintArrowDirection get getHintArrowDirection => hintArrowDirection;

  HintTextAlign get getHintTextAlign => hintTextAlign;

  Color get getHintColor => hintColor;

  TextStyle get getHintTextStyle => hintTextStyle;

  Color get getMaskColor => maskColor;

  Color get getVisibleColor => visibleColor;

  Border get getVisibleBorder => visibleBorder;
}

// This widget is used to draw an overlay mask on top of other widget
// Only the visible area can pass through to the bottom layer.
// ignore: must_be_immutable
class OverlayMaskWidget extends StatelessWidget {
  OverlayMaskConfig config;

  OverlayMaskWidget(this.config);

  // attribute for visible area
  double startPosX = 0;
  double startPosY = 0;
  double btnWidth = 0;
  double btnHeight = 0;

  @override
  Widget build(BuildContext context) {
    if (config == null || config.getVisibleWidgetConfig == null)
      return Container();

    // init the attribute
    initAttr(config.visibleWidgetConfig);

    return Stack(
      children: [
        Column(children: [
          Container(height: startPosY, color: config.getMaskColor),
          Row(
            children: [
              Container(
                  width: startPosX,
                  height: btnHeight,
                  color: config.getMaskColor),
              IgnorePointer(
                ignoring: true,
                child: Container(
                  height: btnHeight,
                  width: btnWidth,
                  decoration: BoxDecoration(
                      border: config.getVisibleBorder,
                      color: config.getVisibleColor),
                ),
              ),
              Expanded(
                  child:
                  Container(height: btnHeight, color: config.getMaskColor))
              // ),
            ],
          ),
          Expanded(child: Container(color: config.getMaskColor)),
        ]),
        _buildHintWidget(config)
      ],
    );
  }

  Widget _buildHintWidget(OverlayMaskConfig config) {
    return config.getHitText.isEmpty
        ? Container()
        : HintPopup(
        config.getHintColor,
        config.getHintArrowDirection,
        config.getHintTextAlign,
        getHintStartOffset(config.getHintArrowDirection),
        config.getHitText,
        hintTextStyle: config.getHintTextStyle);
  }

  void initAttr(WidgetConfig widgetConfig) {
    startPosX = widgetConfig.position.dx;
    startPosY = widgetConfig.position.dy + widgetConfig.offset.dy;
    btnWidth = widgetConfig.size.width;
    btnHeight = widgetConfig.size.height - widgetConfig.offset.dy;
  }

  Offset getHintStartOffset(HintArrowDirection arrowDirection) {
    double marginHeight = AppDimen.hintMargin;
    double dx = 0;
    double dy = 0;
    if (arrowDirection == HintArrowDirection.left) {
      dx = startPosX + btnWidth + marginHeight;
      dy = startPosY + btnHeight / 2;
    } else if (arrowDirection == HintArrowDirection.top) {
      dx = startPosX + btnWidth / 2;
      dy = startPosY + btnHeight + marginHeight;
    } else if (arrowDirection == HintArrowDirection.right) {
      dx = startPosX - marginHeight;
      dy = startPosY + btnHeight / 2;
    } else {
      dx = startPosX + btnWidth / 2;
      dy = startPosY - marginHeight;
    }
    return Offset(dx, dy);
  }
}

class HintPopup extends StatelessWidget {
  final Color backgroundColor;
  final HintArrowDirection direction;
  final HintTextAlign align;
  final Size arrowSize =
  Size(AppDimen.hintArrowWidth, AppDimen.hintArrowHeight);
  final Offset startPos;
  final String hintText;
  final TextStyle hintTextStyle;
  final TextStyle defaultHintTextStyle = TextStyle(
      fontSize: AppDimen.headlineFontSize, fontWeight: FontWeight.w600);

  final double elevation = AppDimen.hintElevation;
  final double radius = AppDimen.hintTextRadius;
  final double textVerticalPadding = AppDimen.hintTextPaddingHeight;
  final double textHorizontalPadding = AppDimen.hintTextPaddingWidth;
  final double textAlignArrowWidth = AppDimen.hintTextAlignArrowWidth;

  HintPopup(this.backgroundColor, this.direction, this.align, this.startPos,
      this.hintText,
      {this.hintTextStyle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_buildArrow(), _buildHintContext()],
    );
  }

  Widget _buildBasicMaterial(Widget child) {
    return Material(
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(color: Colors.transparent, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.75),
                  offset: Offset(0, 2),
                  blurRadius: 4)
            ]),
            child: child));
  }

  Widget _buildArrow() {
    return Positioned(
      left: startPos.dx,
      top: startPos.dy,
      width: arrowSize.width,
      child: _buildBasicMaterial(Container(
          height: arrowSize.height,
          width: arrowSize.width,
          child:
          CustomPaint(painter: ArrowPainter(direction, backgroundColor)))),
    );
  }

  Widget _buildHintContext() {
    TextStyle textStyle =
    hintTextStyle == null ? defaultHintTextStyle : hintTextStyle;
    Size hintTextSize = _getTextSize(hintText, textStyle);
    return Positioned(
        left: getHintTextStartX(hintTextSize),
        top: getHintTextStartY(hintTextSize),
        child: _buildBasicMaterial(Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(radius))),
            padding: EdgeInsets.symmetric(
                vertical: textVerticalPadding,
                horizontal: textHorizontalPadding),
            child: Text(
              hintText,
              style: textStyle,
              textAlign: TextAlign.center,
            ))));
  }

  Size _getTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: ui.TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  double getHintTextStartX(Size hintTextSize) {
    double startX = 0;
    if (direction == HintArrowDirection.left) {
      // Because the triangle rotate, so we use the height of the arrow
      startX = startPos.dx + arrowSize.height;
    } else if (direction == HintArrowDirection.right) {
      // Because the triangle rotate, so we use height
      startX = startPos.dx -
          arrowSize.height -
          hintTextSize.width -
          2 * (textHorizontalPadding);
    } else {
      if (align == HintTextAlign.center) {
        startX = startPos.dx - hintTextSize.width / 2 - textHorizontalPadding;
      } else if (align == HintTextAlign.left) {
        startX = startPos.dx - arrowSize.width / 2 - textAlignArrowWidth;
      } else {
        startX = (startPos.dx + arrowSize.width / 2 + textAlignArrowWidth) -
            hintTextSize.width -
            (2 * textHorizontalPadding);
      }
    }
    return startX < 0 ? 0 : startX;
  }

  double getHintTextStartY(Size hintTextSize) {
    double startY = 0;
    if (direction == HintArrowDirection.top) {
      startY = startPos.dy + arrowSize.height;
    } else if (direction == HintArrowDirection.down) {
      startY = startPos.dy -
          arrowSize.height -
          hintTextSize.height -
          (2 * textVerticalPadding);

      // some render error cause in Android
      if (Platform.isAndroid) {
        // make some offset
        startY += 3;
      }
    } else {
      startY = startPos.dy - hintTextSize.height / 2 - textVerticalPadding;
    }
    return startY < 0 ? 0 : startY;
  }
}

// draw the triangle for pop up bubble
class ArrowPainter extends CustomPainter {
  final HintArrowDirection direction;
  Color color;

  ArrowPainter(this.direction, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = new Paint();
    _paint.strokeWidth = 2.0;
    _paint.color = color;
    _paint.style = PaintingStyle.fill;

    Path path = new Path();
    // Have not check for the left&right
    if (direction == HintArrowDirection.left) {
      path.moveTo(0.0, 0.0);
      path.lineTo(size.height, size.width / 2.0);
      path.lineTo(size.height, -size.width / 2.0);
    } else if (direction == HintArrowDirection.top) {
      path.moveTo(0.0, 0.0);
      path.lineTo(size.width / 2.0, size.height);
      path.lineTo(-size.width / 2.0, size.height);
    } else if (direction == HintArrowDirection.right) {
      path.moveTo(0.0, 0.0);
      path.lineTo(-size.height, size.width / 2.0);
      path.lineTo(-size.height, -size.width / 2.0);
    } else {
      path.moveTo(0.0, 0.0);
      path.lineTo(-size.width / 2.0, -size.height);
      path.lineTo(size.width / 2.0, -size.height);
    }

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
