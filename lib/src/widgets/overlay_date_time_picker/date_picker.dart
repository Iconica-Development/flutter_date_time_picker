// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/overlay_date_time_picker/pickable_date.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    required this.controller,
    required this.theme,
    required this.textStyle,
    required this.onSelectDate,
    required this.date,
    required this.showWeekDays,
    required this.dateTimeConstraint,
  });

  final DateTimePickerController controller;
  final DateTimePickerTheme theme;
  final TextStyle textStyle;
  final void Function(DateTime date) onSelectDate;
  final DateTime date;
  final bool showWeekDays;
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

    int length = DateTime(date.year, date.month).daysInMonth() + daysToSkip;
    int daysToAdd = DateTime.daysPerWeek - length % DateTime.daysPerWeek;
    return Column(
      children: [
        if (showWeekDays) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: List.generate(DateTime.daysPerWeek, (index) {
                DateFormat dateFormatter = DateFormat("EE");
                return Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        // The first day in November 2022 is monday
                        // We use it to properly show monday as the first day and sunday as the last one
                        dateFormatter.format(DateTime(2022, 11, index)),
                        style: textStyle.copyWith(fontWeight: FontWeight.bold),
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
                    isOffMonth: date.month != todayDate.month,
                    isDisabled:
                        isDisabled(addedIndex + index, daysToSkip, todayDate),
                    isSelected: controller.selectedDate == todayDate,
                    isToday: isToday(todayDate) && controller.highlightToday,
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
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isDisabled(int index, int daysToSkip, DateTime date) {
    return DateTime(
          date.year,
          date.month,
          index + 1 - daysToSkip,
        ).containsAny(
          controller.disabledDates ?? [],
        ) ||
        !dateTimeConstraint.inRange(date);
  }
}
