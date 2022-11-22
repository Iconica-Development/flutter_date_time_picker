// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';

class DateTimePickerTheme {
  /// The [DateTimePickerTheme] to style [DragDownDateTimePicker] in. Define a custom shape for the dates and specifically style
  /// a basic, highlighted, selected and disabled date.
  const DateTimePickerTheme({
    this.paginationSize = 25,
    this.weekDateBoxSize = 35,
    this.monthDateBoxSize = 45,
    this.markedIndicatorColor,
    this.dateBoxShape = DateBoxShape.roundedRectangle,
    this.backgroundColor = Colors.white,
    this.weekViewSize = 0.2,
    this.monthViewSize = 0.6,
    this.weekMonthTriggerSize = 0.3,
    this.shapeBorder,
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

  /// The size of the week view of the date picker. Enter a value between 0 and 1.
  final double weekViewSize;

  /// The size of the month view of the date picker. Enter a value between 0 and 1 that's bigger than the weekViewSize.
  final double monthViewSize;

  /// The position where the week view changes to month view and the other way around. Enter a value between 0 and 1 that's between the weekViewSize and the monthViewSize.
  final double weekMonthTriggerSize;

  /// The size of the buttons for navigation the different pages
  final double paginationSize;

  /// The shape of the border using a [ShapeBorder]
  final ShapeBorder? shapeBorder;
}
