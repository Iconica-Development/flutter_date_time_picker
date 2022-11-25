// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/week_date_time_picker/week_date_time_picker.dart';
import 'package:intl/intl.dart';

class WeekDateTimePickerSheet extends StatelessWidget {
  const WeekDateTimePickerSheet({
    required this.dateTimePickerController,
    required this.weekDateBoxSize,
    this.showHeader = false,
    Key? key,
  }) : super(key: key);

  final DateTimePickerController dateTimePickerController;
  final bool showHeader;
  final double weekDateBoxSize;

  String _getDateHeader(BuildContext context) {
    var weekDays =
        dateTimePickerController.browsingDate.daysOfWeek();

    var firstDay = weekDays.first.day.toString();

    var lastDay = weekDays.last.day.toString();

    var monthYear =
        DateFormat("MMMM, yyyy", Localizations.localeOf(context).toString())
            .format(dateTimePickerController.browsingDate);

    return '$firstDay - $lastDay $monthYear';
  }

  @override
  Widget build(BuildContext context) {
    var theme = dateTimePickerController.theme;

    return Column(
      children: [
        if (dateTimePickerController.header != null)
          Align(
            alignment: Alignment.topCenter,
            child: dateTimePickerController.header!,
          ),
        const SizedBox(
          height: 10,
        ),
        if (showHeader) ...[
          Text(
            _getDateHeader(context),
            style: theme.baseTheme.textStyle!.copyWith(fontSize: 9),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: PageView(
            controller: dateTimePickerController.pageController,
            onPageChanged: (i) {
              if (i == 0) {
                dateTimePickerController.onPageChanged(
                  dateTimePickerController.browsingDate.subtract(
                    const Duration(days: 7),
                  ),
                );
              } else if (i == 2) {
                dateTimePickerController.onPageChanged(
                  dateTimePickerController.browsingDate.add(
                    const Duration(days: 7),
                  ),
                );
              }
            },
            children: [
              WeekDateTimePicker(
                dateTimePickerController: dateTimePickerController,
                date: dateTimePickerController.browsingDate.subtract(
                  const Duration(days: 7),
                ),
                weekDateBoxSize: weekDateBoxSize,
              ),
              WeekDateTimePicker(
                dateTimePickerController: dateTimePickerController,
                date: dateTimePickerController.browsingDate,
                weekDateBoxSize: weekDateBoxSize,
              ),
              WeekDateTimePicker(
                dateTimePickerController: dateTimePickerController,
                date: dateTimePickerController.browsingDate.add(
                  const Duration(days: 7),
                ),
                weekDateBoxSize: weekDateBoxSize,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: theme.barTheme.barHeight,
          width: theme.barTheme.barWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: theme.barTheme.barColor.withOpacity(
              theme.barTheme.barOpacity,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
