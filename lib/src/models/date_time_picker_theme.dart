// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';

class DateTimePickerTheme {
  /// The [DateTimePickerTheme] to style [DragDownDateTimePicker] in. Define a custom shape for the dates and specifically style
  /// a basic, highlighted, selected and disabled date.
  const DateTimePickerTheme({
    this.prevIcon,
    this.nextIcon,
    this.dateFormatMonth,
    this.dateFormatWeekday,
    this.paginationSize = 25,
    this.weekDateBoxSize = 35,
    this.monthDateBoxSize = 45,
    this.markedIndicatorColor,
    this.dateBoxShape = DateBoxShape.roundedRectangle,
    this.backgroundColor = Colors.white,
    this.weekViewSize = 0.2,
    this.monthViewSize = 0.6,
    this.weekMonthTriggerSize = 0.3,
    this.shapeDecoration,
    this.baseTheme = const DateBoxTheme(
        backgroundColor: Colors.white,
        textStyle: TextStyle(color: Colors.black)),
    this.highlightTheme = const DateBoxTheme(
      backgroundColor: Colors.blue,
      textStyle: TextStyle(color: Colors.white),
    ),
    this.selectedTheme = const DateBoxTheme(
      backgroundColor: Color(0xFFBBDEFB),
      textStyle: TextStyle(color: Colors.blue),
    ),
    this.disabledTheme = const DateBoxTheme(
      backgroundColor: Colors.grey,
      textStyle: TextStyle(color: Colors.white),
    ),
    this.barTheme = const DateTimePickerBarTheme(),
    this.monthWeekDayHeaders = false,
    this.calenderPadding = const EdgeInsets.all(8.0),
    this.monthDatePadding = const EdgeInsets.symmetric(vertical: 12.0),
  });

  /// enum to define a shape dor the date. use [DateBoxShape.circle].
  /// For a ciruclar date, [DateBoxShape.rectangle] for a plain box and [DateBoxShape.roundedRectangle] to het a rectangle with small rounded borders.
  final DateBoxShape dateBoxShape;

  /// This theme is used to style a default look for the dates.
  final DateBoxTheme baseTheme;

  /// This theme is used for when a specific date is highlighted.
  final DateBoxTheme highlightTheme;

  /// This theme is used for when a specific date is slected by the user.
  final DateBoxTheme selectedTheme;

  /// This theme is used for when a specific date is disabled.
  final DateBoxTheme disabledTheme;

  /// This theme is used for the bar of the date picker.
  final DateTimePickerBarTheme barTheme;

  /// Size of date box in a week view.
  final double weekDateBoxSize;

  /// Size of date box in a month view.
  final double monthDateBoxSize;

  /// The Padding around the month name in the month view.
  final EdgeInsetsGeometry monthDatePadding;

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

  /// The decoration of the box that encapsulates the date picker
  /// Requires [ShapeBorder], default shadow and backgroundcolor implemented
  /// Image and gradient optional
  final ShapeDecoration? shapeDecoration;

  /// If true the first letters of the weekdays will be displayed above the days of the month
  final bool monthWeekDayHeaders;

  /// This function allows you to change formatting of the month-text
  final String Function(String date)? dateFormatMonth;

  /// This function allows you to change formatting of weekday-text
  final String Function(String date)? dateFormatWeekday;

  final WidgetBuilder? nextIcon;

  final WidgetBuilder? prevIcon;

  /// The padding surrounding the calendar
  final EdgeInsetsGeometry calenderPadding;
}
