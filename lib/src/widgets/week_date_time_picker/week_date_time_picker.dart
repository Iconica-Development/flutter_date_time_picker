// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/extensions/time_of_day.dart';
import 'package:flutter_date_time_picker/src/models/date_box_current_theme.dart';
import 'package:flutter_date_time_picker/src/widgets/marked_icon.dart';
import 'package:intl/intl.dart';

/// `WeekDateTimePicker` is a StatelessWidget that represents a picker for a date within a week.
/// It provides a row of dates for the week and allows the user to select a date.
class WeekDateTimePicker extends StatelessWidget {
  /// Creates a new instance of `WeekDateTimePicker`.
  ///
  /// The [dateTimePickerController], [dateTimePickerConfiguration], [date], and [weekDateBoxSize] parameters must not be null.
  ///
  /// * [dateTimePickerController]: The controller for the date time picker.
  /// * [dateTimePickerConfiguration]: The configuration for the date time picker.
  /// * [date]: The date that this widget represents.
  /// * [weekDateBoxSize]: The size of the box for each date in the week.
  const WeekDateTimePicker({
    required this.dateTimePickerController,
    required this.dateTimePickerConfiguration,
    required this.date,
    required this.weekDateBoxSize,
    Key? key,
  }) : super(key: key);

  final DateTimePickerController dateTimePickerController;
  final DateTimePickerConfiguration dateTimePickerConfiguration;

  final DateTime date;

  final double weekDateBoxSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        date.daysOfWeek().length,
        (index) {
          late DateBoxCurrentTheme currentDateBoxTheme;

          currentDateBoxTheme = determineCurrentDateBoxTheme(
              context, index, dateTimePickerConfiguration.theme);
          return GestureDetector(
            onTap: isDisabled(
              index,
            )
                ? null
                : () async {
                    TimeOfDay? timeOfDay;

                    var selectedDate = date.daysOfWeek()[index];

                    timeOfDay = const TimeOfDay(hour: 0, minute: 0);

                    if (dateTimePickerConfiguration.pickTime) {
                      timeOfDay = await displayTimePicker(
                          context, dateTimePickerController);
                    }

                    if (dateTimePickerConfiguration.wrongTimeDialog != null) {
                      if (timeOfDay != null &&
                          timeOfDay.containsAny(
                            dateTimePickerConfiguration.disabledTimes ?? [],
                          )) {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                dateTimePickerConfiguration.wrongTimeDialog!,
                          );
                        }
                      }
                    }

                    var selectedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      timeOfDay!.hour,
                      timeOfDay.minute,
                    );

                    dateTimePickerController.onTapDay(selectedDateTime);
                  },
            child: SizedBox(
              width: 40,
              height: 60,
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    DateFormat.E(Localizations.localeOf(context).toString())
                        .format(
                          date.daysOfWeek().elementAt(index),
                        )
                        .toUpperCase()[0],
                    style:
                        dateTimePickerConfiguration.theme.baseTheme.textStyle,
                  ),
                  const Spacer(),
                  Container(
                    height: weekDateBoxSize,
                    width: weekDateBoxSize,
                    decoration: BoxDecoration(
                      color: currentDateBoxTheme.backgroundColor,
                      borderRadius:
                          _determineBorderRadius(dateTimePickerConfiguration),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            date.daysOfWeek().elementAt(index).day.toString(),
                            style: currentDateBoxTheme.textStyle,
                          ),
                        ),
                        if (shouldMark(index)) ...[
                          MarkedIcon(
                            width: weekDateBoxSize / 3,
                            height: weekDateBoxSize / 3,
                            color: dateTimePickerConfiguration
                                .theme.markedIndicatorColor,
                          )
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  DateBoxCurrentTheme determineCurrentDateBoxTheme(
    BuildContext context,
    int index,
    DateTimePickerTheme theme,
  ) {
    DateBoxCurrentTheme determinedTheme = DateBoxCurrentTheme(
      theme.baseTheme.backgroundColor ?? Colors.transparent,
      theme.baseTheme.textStyle ?? const TextStyle(color: Colors.black),
    );

    if (isDisabled(index)) {
      determinedTheme = DateBoxCurrentTheme(
        theme.disabledTheme.backgroundColor ?? Theme.of(context).disabledColor,
        theme.disabledTheme.textStyle ?? const TextStyle(color: Colors.white),
      );
    }
    if (isSelected(index)) {
      determinedTheme = DateBoxCurrentTheme(
          theme.selectedTheme.backgroundColor ??
              Theme.of(context).primaryColor.withOpacity(0.3),
          theme.selectedTheme.textStyle ??
              TextStyle(color: Theme.of(context).primaryColor));
    }
    if (shouldHighlight(index)) {
      determinedTheme = DateBoxCurrentTheme(
          theme.highlightTheme.backgroundColor ??
              Theme.of(context).primaryColor,
          theme.highlightTheme.textStyle ??
              const TextStyle(color: Colors.white));
    }

    return determinedTheme;
  }

  bool shouldHighlight(int index) {
    return date.daysOfWeek().elementAt(index).equals(
          dateTimePickerConfiguration.highlightToday
              ? DateTime.now()
              : dateTimePickerController.selectedDate,
        );
  }

  bool isSelected(int index) {
    return date
        .daysOfWeek()
        .elementAt(index)
        .equals(dateTimePickerController.selectedDate);
  }

  bool isDisabled(int index) {
    return date
        .daysOfWeek()
        .elementAt(index)
        .containsAny(dateTimePickerConfiguration.disabledDates ?? []);
  }

  bool shouldMark(int index) {
    return !date.daysOfWeek().elementAt(index).equals(
              dateTimePickerConfiguration.highlightToday
                  ? DateTime.now()
                  : dateTimePickerController.selectedDate,
            ) &&
        date
            .daysOfWeek()
            .elementAt(index)
            .containsAny(dateTimePickerConfiguration.markedDates ?? []);
  }

  BorderRadius _determineBorderRadius(
      DateTimePickerConfiguration dateTimePickerConfiguration) {
    switch (dateTimePickerConfiguration.theme.dateBoxShape) {
      case DateBoxShape.circle:
        return BorderRadius.circular(weekDateBoxSize * 2);
      case DateBoxShape.rectangle:
        return BorderRadius.zero;
      case DateBoxShape.roundedRectangle:
        return BorderRadius.circular(weekDateBoxSize / 4.5);
    }
  }

  displayTimePicker(BuildContext context,
      DateTimePickerController dateTimePickerController) async {
    return await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat:
                    dateTimePickerConfiguration.alwaysUse24HourFormat),
            child: child!,
          );
        });
  }
}
