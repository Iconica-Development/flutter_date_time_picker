// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_date_time_picker/src/models/date_time_picker_bar_theme.dart';

class DateTimePickerTheme {
  /// The [DateTimePickerTheme] to style [DateTimePicker] in. Define a custom shape for the dates and specifically style
  /// a basic, hightlighted, selected and disabled date.
  const DateTimePickerTheme({
    this.weekDateBoxSize = 35,
    this.monthDateBoxSize = 45,
    this.markedIndicatorColor,
    this.dateBoxShape = DateBoxShape.roundedRectangle,
    this.backgroundColor = Colors.white,
    this.baseTheme = const DateBoxBaseTheme(
      Colors.white,
      TextStyle(color: Colors.black),
    ),
    this.highlightTheme = const DateBoxHighlightTheme(
      Colors.blue,
      TextStyle(color: Colors.white),
    ),
    this.selectedTheme = const DateBoxSelectedTheme(
      Color(0xFFBBDEFB),
      TextStyle(color: Colors.blue),
    ),
    this.disabledTheme = const DateBoxDisabledTheme(
      Colors.grey,
      TextStyle(color: Colors.white),
    ),
    this.barTheme = const DateTimePickerBarTheme(),
  });

  /// enum to define a shape dor the date. use [DateBoxShape.circle].
  /// For a ciruclar date, [DateBoxShape.rectangle] for a plain box and [DateBoxShape.roundedRectangle] to het a rectangle with small rounded borders.
  final DateBoxShape dateBoxShape;

  /// This theme is used to style a default look for the dates.
  final DateBoxBaseTheme baseTheme;

  /// This theme is used for when a specific date is highlighted.
  final DateBoxHighlightTheme highlightTheme;

  /// This theme is used for when a specific date is slected by the user.
  final DateBoxSelectedTheme selectedTheme;

  /// This theme is used for when a specific date is disabled.
  final DateBoxDisabledTheme disabledTheme;

  /// This theme is used for the bar of the date picker.
  final DateTimePickerBarTheme barTheme;

  /// Size of date box in a week view.
  final double weekDateBoxSize;

  /// Size of date box in a month view.
  final double monthDateBoxSize;

  /// The color used for a indicator for a marked date.
  final Color? markedIndicatorColor;

  /// The color used for a background of the date picker.
  final Color backgroundColor;
}
