// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/widgets/overlay_date_time_picker/pickable_date.dart';
import 'package:intl/intl.dart';

/// `DatePicker` is a StatelessWidget that represents a date picker.
/// It provides a way to select a date from a calendar-like interface.
class DatePicker extends StatelessWidget {
  /// Creates a new instance of `DatePicker`.
  const DatePicker({
    super.key,
    required this.controller,
    required this.configuration,
    required this.theme,
    required this.weekdayTextStyle,
    required this.onSelectDate,
    required this.date,
    required this.showWeekDays,
    required this.dateTimeConstraint,
  });

  /// The controller for managing date selection.
  final DateTimePickerController controller;

  /// The configuration for the date picker.
  final DateTimePickerConfiguration configuration;

  /// The theme for the date picker.
  final DateTimePickerTheme theme;

  /// The text style for displaying the weekday names.
  final TextStyle weekdayTextStyle;

  /// Callback function invoked when a date is selected.
  final void Function(DateTime date) onSelectDate;

  /// The date to display in the picker.
  final DateTime date;

  /// Whether to show the weekday names.
  final bool showWeekDays;

  /// The constraint for selecting dates.
  final DateTimeConstraint dateTimeConstraint;

  @override
  Widget build(BuildContext context) {
    int daysToSkip = DateTime(
      date.year,
      date.month,
      0,
      12,
    ).weekday;

    int addedIndex = 0;

    if (daysToSkip >= DateTime.daysPerWeek) {
      addedIndex = DateTime.daysPerWeek;
    }

    int length = DateTime(date.year, date.month).daysInMonth() + daysToSkip % 7;
    int daysToAdd = (DateTime.daysPerWeek - length) % DateTime.daysPerWeek;
    return Column(
      children: [
        if (showWeekDays) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: List.generate(DateTime.daysPerWeek, (index) {
                DateFormat dateFormatter = DateFormat(
                    "EE", Localizations.localeOf(context).toLanguageTag());
                var date = dateFormatter.format(DateTime(2022, 11, index));
                if (theme.dateFormatWeekday != null) {
                  date = theme.dateFormatWeekday!
                      .call(dateFormatter.format(DateTime(2022, 11, index)));
                }
                return Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        // The first day in November 2022 is monday
                        // We use it to properly show monday as the first day and sunday as the last one
                        date,
                        style: weekdayTextStyle,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
        Expanded(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: DateTime.daysPerWeek,
            children: List.generate(
              length + daysToAdd,
              (index) {
                DateTime todayDate = DateTime(
                  date.year,
                  date.month,
                  addedIndex + index + 1 - daysToSkip,
                );
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: PickableDate(
                    isMarked: configuration.markedDates?.any(
                          (e) => isSameDay(e, todayDate),
                        ) ??
                        false,
                    isOffMonth: date.month != todayDate.month,
                    isDisabled:
                        isDisabled(addedIndex + index, daysToSkip, todayDate),
                    isSelected: controller.selectedDate == todayDate,
                    isToday: isToday(todayDate) && configuration.highlightToday,
                    theme: theme,
                    date: todayDate,
                    onPressed: onSelectDate,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    return isSameDay(date, now);
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool isDisabled(int index, int daysToSkip, DateTime date) {
    return DateTime(
          date.year,
          date.month,
          index + 1 - daysToSkip,
        ).containsAny(
          configuration.disabledDates ?? [],
        ) ||
        !dateTimeConstraint.inRange(date);
  }
}
