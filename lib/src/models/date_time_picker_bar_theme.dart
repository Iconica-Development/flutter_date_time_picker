import 'package:flutter/material.dart';

class DateTimePickerBarTheme {
  /// The [DateTimePickerBarTheme] to style bar of the [DateTimePicker] in.
  /// Define a custom size for the bar and it's color/opacity.
  const DateTimePickerBarTheme({
    this.barColor = Colors.grey,
    this.barOpacity = 0.3,
    this.barWidth = 50,
    this.barHeight = 3,
  });

  /// The color used for the bar shown at the bottom of the date picker.
  final Color barColor;

  /// The opacity of the color used for the bar that's shown at the bottom of the date picker.
  final double barOpacity;

  /// The height of the bar shown at the bottom of the date picker.
  final double barHeight;

  /// The width of the bar shown at the bottom of the date picker.
  final double barWidth;
}