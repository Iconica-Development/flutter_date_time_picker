// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/models/date_time_picker_theme.dart';

class DateTimePickerController extends ChangeNotifier {
  DateTimePickerController({
    required this.theme,
    required this.highlightToday,
    required this.initialDate,
    this.pickTime = false,
    this.alwaysUse24HourFormat,
    this.header,
    this.wrongTimeDialog,
    this.markedDates,
    this.disabledDates,
    this.disabledTimes,
    this.onTapDayCallBack,
    this.onBorderScrollCallback,
  });

  /// Whether the current day should be highlighted in the [DragDownDateTimePicker]
  final bool highlightToday;

  /// a [bool] to set de clock on [TimePickerDialog] to a fixed 24 or 12-hour format.
  /// By default this gets determined by the settings on the user device.
  final bool? alwaysUse24HourFormat;

  /// Widget shown at the top of the [DragDownDateTimePicker]
  final Widget? header;

  final Widget? wrongTimeDialog;

  /// Visual properties for the [DragDownDateTimePicker]
  final DateTimePickerTheme theme;

  /// [markedDates] contain the dates [DateTime] that will be marked in the [DragDownDateTimePicker] by a small dot.
  final List<DateTime>? markedDates;

  /// a [List] of [DateTime] objects that will be disabled and cannot be interacted with whatsoever.
  final List<DateTime>? disabledDates;

  /// a [List] of [TimeOfDay] objects that cannot be picked in the [TimePickerDialog].
  final List<TimeOfDay>? disabledTimes;

  /// [pickTime] is a [bool] that determines if the user is able to pick a time after picking a date using the [TimePickerDialog].
  final bool pickTime;

  /// Callback that provides the date tapped on as a [DateTime] object.
  final Function(DateTime)? onTapDayCallBack;

  /// Callback that provides the new date which is scroll to. If this is null the scroll feature is disabled.
  final Function(DateTime)? onBorderScrollCallback;

  final DateTime initialDate;

  final PageController _pageController = PageController(initialPage: 1);

  late DateTime browsingDate = initialDate;
  late DateTime selectedDate = initialDate;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(DateTime date) {
    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        browsingDate = date;

        notifyListeners();

        _pageController.jumpToPage(1);
      },
    );
  }

  void onTapDay(DateTime date) {
    browsingDate = date;
    selectedDate = date;

    notifyListeners();

    if (onTapDayCallBack != null) {
      onTapDayCallBack!.call(
        date,
      );
    }
  }

  void onBorderScroll(DateTime date) {
    browsingDate = date;
    selectedDate = date;

    notifyListeners();

    onBorderScrollCallback?.call(
      date,
    );
  }

  PageController get pageController => _pageController;

  void setBrowsingDate(DateTime date) {
    browsingDate = date;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
