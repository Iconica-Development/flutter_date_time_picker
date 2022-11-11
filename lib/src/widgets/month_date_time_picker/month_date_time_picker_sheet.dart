// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/month_date_time_picker/month_date_time_picker.dart';
import 'package:intl/intl.dart';

class MonthDateTimePickerSheet extends StatelessWidget {
  const MonthDateTimePickerSheet({
    required this.dateTimePickerController,
    required this.monthDateBoxSize,
    Key? key,
  }) : super(key: key);

  final DateTimePickerController dateTimePickerController;
  final double monthDateBoxSize;

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
        Text(
          DateFormat.yMMMM().format(
            dateTimePickerController.browsingDate,
          ),
          style: theme.baseTheme.textStyle!
              .copyWith(fontSize: 25),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.33,
          child: PageView(
            controller: dateTimePickerController.pageController,
            onPageChanged: (i) {
              if (i == 0) {
                dateTimePickerController.onPageChanged(
                  dateTimePickerController.browsingDate.subtract(
                    Duration(
                      days: DateTime(dateTimePickerController.browsingDate.year,
                              dateTimePickerController.browsingDate.month)
                          .daysInMonth(),
                    ),
                  ),
                );
              } else if (i == 2) {
                dateTimePickerController.onPageChanged(
                  dateTimePickerController.browsingDate.add(
                    Duration(
                      days: DateTime(dateTimePickerController.browsingDate.year,
                              dateTimePickerController.browsingDate.month)
                          .daysInMonth(),
                    ),
                  ),
                );
              }
            },
            children: [
              MonthDateTimePicker(
                  date: dateTimePickerController.browsingDate.month == 1
                      ? DateTime(
                          dateTimePickerController.browsingDate.year - 1, 12, 1)
                      : DateTime(dateTimePickerController.browsingDate.year,
                          dateTimePickerController.browsingDate.month - 1, 1),
                  monthDateBoxSize: monthDateBoxSize,
                  dateTimePickerController: dateTimePickerController),
              MonthDateTimePicker(
                  date: DateTime(
                    dateTimePickerController.browsingDate.year,
                    dateTimePickerController.browsingDate.month,
                    1,
                  ),
                  dateTimePickerController: dateTimePickerController,
                  monthDateBoxSize: monthDateBoxSize),
              MonthDateTimePicker(
                  date: dateTimePickerController.browsingDate.month == 12
                      ? DateTime(
                          dateTimePickerController.browsingDate.year + 1,
                          1,
                          1,
                        )
                      : DateTime(dateTimePickerController.browsingDate.year,
                          dateTimePickerController.browsingDate.month + 1, 1),
                  dateTimePickerController: dateTimePickerController,
                  monthDateBoxSize: monthDateBoxSize),
            ],
          ),
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