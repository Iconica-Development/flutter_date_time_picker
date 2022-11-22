import 'package:flutter/material.dart';

class ArrowedBorder extends ShapeBorder {
  const ArrowedBorder();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight);
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight);
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        rect,
        const Radius.circular(16),
      ))
      ..moveTo(rect.bottomCenter.dx - 15, rect.bottomCenter.dy)
      ..relativeLineTo(15, 20)
      ..relativeLineTo(15, -20)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return this;
  }
}
