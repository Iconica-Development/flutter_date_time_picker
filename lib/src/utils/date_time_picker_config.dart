// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';

/// `DateTimePickerConfiguration` is a class that holds the configuration for a DateTimePicker.
/// It provides various options to customize the behavior and appearance of the DateTimePicker.
class DateTimePickerConfiguration {
  /// Creates a new instance of `DateTimePickerConfiguration`.
  DateTimePickerConfiguration({
    required this.theme,
    this.pickTime = false,
    this.highlightToday = true,
    this.alwaysUse24HourFormat,
    this.header,
    this.wrongTimeDialog,
    this.markedDates,
    this.disabledDates,
    this.disabledTimes,
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
}
