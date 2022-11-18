// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/overlay_date_time_picker/pickable_date.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    required this.controller,
    required this.theme,
    required this.onSelectDate,
    required this.date,
  });

  final DateTimePickerController controller;
  final DateTimePickerTheme theme;
  final void Function(DateTime date) onSelectDate;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    int daysToSkip = DateTime(
      date.year,
      date.month,
      0,
      12,
    ).weekday;

    int addedIndex = 0;

    if (daysToSkip >= 7) {
      addedIndex = 7;
    }

    int length = DateTime(date.year, date.month).daysInMonth() + daysToSkip;
    int daysToAdd = 7 - length % 7;
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
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
              isDisabled: isDisabled(addedIndex + index, daysToSkip),
              isSelected: controller.selectedDate == todayDate,
              isToday: isToday(todayDate) && controller.highlightToday,
              theme: theme,
              date: todayDate,
              onPressed: onSelectDate,
            ),
          );
        },
      ),
    );
  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isDisabled(int index, int daysToSkip) {
    return DateTime(
      date.year,
      date.month,
      index + 1 - daysToSkip,
    ).containsAny(
      controller.disabledDates ?? [],
    );
  }
}
