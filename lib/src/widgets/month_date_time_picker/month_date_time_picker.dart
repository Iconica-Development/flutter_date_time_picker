// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/enums/date_box_shape.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/extensions/time_of_day.dart';
import 'package:flutter_date_time_picker/src/models/date_box_current_theme.dart';
import 'package:flutter_date_time_picker/src/models/date_time_picker_theme.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_config.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/marked_icon.dart';
import 'package:intl/intl.dart';

/// `MonthDateTimePicker` is a StatelessWidget that represents a picker for a date within a month.
/// It provides a grid of dates for the month and allows the user to select a date.
class MonthDateTimePicker extends StatelessWidget {
  /// Creates a new instance of `MonthDateTimePicker`.
  const MonthDateTimePicker({
    required this.date,
    required this.dateTimePickerController,
    required this.monthDateBoxSize,
    required this.dateTimePickerConfiguration,
    Key? key,
  }) : super(key: key);

  /// The date of the month to display.
  final DateTime date;

  /// The controller for managing date and time selection.
  final DateTimePickerController dateTimePickerController;

  /// The size of each date box in the month grid.
  final double monthDateBoxSize;

  /// The configuration for the date and time picker.
  final DateTimePickerConfiguration dateTimePickerConfiguration;

  @override
  Widget build(BuildContext context) {
    int daysToSkip = DateTime(
      date.year,
      date.month,
      0,
      12,
    ).weekday;

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          children: [
            if (dateTimePickerConfiguration.theme.monthWeekDayHeaders)
              Row(
                children: List.generate(
                  7,
                  (index) => Expanded(
                    child: Center(
                      child: Text(
                        DateFormat.E(Localizations.localeOf(context).toString())
                            .format(
                              date.daysOfWeek().elementAt(index),
                            )
                            .toUpperCase()[0],
                        style: dateTimePickerConfiguration
                            .theme.baseTheme.textStyle,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 5,
                crossAxisCount: 7,
                children: List.generate(
                  DateTime(date.year, date.month).daysInMonth() +
                      (daysToSkip >= 7 ? 0 : daysToSkip),
                  (index) {
                    late DateBoxCurrentTheme currentDateBoxTheme;

                    int addedIndex = index;

                    if (daysToSkip >= 7) {
                      addedIndex = index + 7;
                    }
                    if (addedIndex < daysToSkip) {
                      return const SizedBox.shrink();
                    }

                    currentDateBoxTheme = determineCurrentDateBoxTheme(
                        context,
                        addedIndex,
                        daysToSkip,
                        dateTimePickerConfiguration.theme);

                    return GestureDetector(
                      onTap: isDisabled(
                        addedIndex,
                        daysToSkip,
                      )
                          ? null
                          : () async {
                              TimeOfDay? timeOfDay;

                              DateTime selectedDate = DateTime(
                                date.year,
                                date.month,
                                addedIndex + 1 - daysToSkip,
                              );

                              timeOfDay = const TimeOfDay(hour: 0, minute: 0);

                              if (dateTimePickerConfiguration.pickTime) {
                                timeOfDay = await displayTimePicker(
                                    context, dateTimePickerConfiguration);
                              }

                              if (dateTimePickerConfiguration.wrongTimeDialog !=
                                  null) {
                                if (timeOfDay != null &&
                                    timeOfDay.containsAny(
                                      dateTimePickerConfiguration
                                              .disabledTimes ??
                                          [],
                                    )) {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          dateTimePickerConfiguration
                                              .wrongTimeDialog!,
                                    );
                                  }
                                }
                              }

                              DateTime selectedDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                timeOfDay!.hour,
                                timeOfDay.minute,
                              );

                              dateTimePickerController
                                  .onTapDay(selectedDateTime);
                            },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          color: currentDateBoxTheme.backgroundColor,
                          borderRadius: _determineBorderRadius(
                              dateTimePickerConfiguration),
                        ),
                        height: monthDateBoxSize,
                        width: monthDateBoxSize,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                  (addedIndex + 1 - daysToSkip).toString(),
                                  style: currentDateBoxTheme.textStyle),
                            ),
                            if (shouldMark(
                              addedIndex,
                              daysToSkip,
                            )) ...[
                              MarkedIcon(
                                width: monthDateBoxSize / 4,
                                height: monthDateBoxSize / 4,
                                color: dateTimePickerConfiguration
                                    .theme.markedIndicatorColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool shouldHighlight(int index, int daysToSkip) {
    return DateTime(
      date.year,
      date.month,
      index + 1 - daysToSkip,
    ).equals(
      dateTimePickerConfiguration.highlightToday
          ? DateTime.now()
          : dateTimePickerController.selectedDate,
    );
  }

  DateBoxCurrentTheme determineCurrentDateBoxTheme(
    BuildContext context,
    int index,
    int daysToSkip,
    DateTimePickerTheme theme,
  ) {
    DateBoxCurrentTheme determinedTheme = DateBoxCurrentTheme(
      theme.baseTheme.backgroundColor ?? Colors.transparent,
      theme.baseTheme.textStyle ?? const TextStyle(color: Colors.black),
    );

    if (isDisabled(index, daysToSkip)) {
      determinedTheme = DateBoxCurrentTheme(
        theme.disabledTheme.backgroundColor ?? Theme.of(context).disabledColor,
        theme.disabledTheme.textStyle ?? const TextStyle(color: Colors.white),
      );
    }
    if (isSelected(index, daysToSkip)) {
      determinedTheme = DateBoxCurrentTheme(
          theme.selectedTheme.backgroundColor ??
              Theme.of(context).primaryColor.withOpacity(0.3),
          theme.selectedTheme.textStyle ??
              TextStyle(color: Theme.of(context).primaryColor));
    }
    if (shouldHighlight(index, daysToSkip)) {
      determinedTheme = DateBoxCurrentTheme(
          theme.highlightTheme.backgroundColor ??
              Theme.of(context).primaryColor,
          theme.highlightTheme.textStyle ??
              const TextStyle(color: Colors.white));
    }

    return determinedTheme;
  }

  bool isDisabled(int index, int daysToSkip) {
    return DateTime(
      date.year,
      date.month,
      index + 1 - daysToSkip,
    ).containsAny(
      dateTimePickerConfiguration.disabledDates ?? [],
    );
  }

  bool isSelected(int index, int daysToSkip) {
    return DateTime(
      date.year,
      date.month,
      index + 1 - daysToSkip,
    ).equals(dateTimePickerController.selectedDate);
  }

  bool shouldMark(int index, int daysToSkip) {
    return !DateTime(
          date.year,
          date.month,
          index + 1 - daysToSkip,
        ).equals(
          dateTimePickerConfiguration.highlightToday
              ? DateTime.now()
              : dateTimePickerController.selectedDate,
        ) &&
        DateTime(
          date.year,
          date.month,
          index + 1 - daysToSkip,
        ).containsAny(
          dateTimePickerConfiguration.markedDates ?? [],
        );
  }

  BorderRadius _determineBorderRadius(
      DateTimePickerConfiguration dateTimePickerConfiguration) {
    switch (dateTimePickerConfiguration.theme.dateBoxShape) {
      case DateBoxShape.circle:
        return BorderRadius.circular(monthDateBoxSize * 2);
      case DateBoxShape.rectangle:
        return BorderRadius.zero;
      case DateBoxShape.roundedRectangle:
        return BorderRadius.circular(monthDateBoxSize / 4.5);
    }
  }
}

displayTimePicker(BuildContext context,
    DateTimePickerConfiguration dateTimePickerConfiguration) async {
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
