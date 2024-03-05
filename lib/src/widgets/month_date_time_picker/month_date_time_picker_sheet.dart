// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_config.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/month_date_time_picker/month_date_time_picker.dart';
import 'package:intl/intl.dart';

/// `MonthDateTimePickerSheet` is a StatelessWidget that represents a sheet for picking a date within a month.
/// It provides a grid of dates for the month and allows the user to select a date.
class MonthDateTimePickerSheet extends StatelessWidget {
  /// Creates a new instance of `MonthDateTimePickerSheet`.
  const MonthDateTimePickerSheet({
    required this.dateTimePickerController,
    required this.dateTimePickerConfiguration,
    required this.monthDateBoxSize,
    required this.monthDatePadding,
    super.key,
  });

  /// The controller for managing date and time selection.
  final DateTimePickerController dateTimePickerController;

  /// The configuration for the date and time picker.
  final DateTimePickerConfiguration dateTimePickerConfiguration;

  /// The size of the month date box.
  final double monthDateBoxSize;

  /// The padding around the month date.
  final EdgeInsetsGeometry monthDatePadding;

  @override
  Widget build(BuildContext context) {
    var theme = dateTimePickerConfiguration.theme;
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        if (dateTimePickerConfiguration.header != null) ...[
          Align(
            alignment: Alignment.topCenter,
            child: dateTimePickerConfiguration.header!,
          ),
        ],
        Padding(
          padding: monthDatePadding,
          child: Text(
            // use localization to get the month name
            DateFormat.yMMMM(Localizations.localeOf(context).toString())
                .format(dateTimePickerController.browsingDate),
            style: theme.baseTheme.textStyle!.copyWith(fontSize: 25),
          ),
        ),
        SizedBox(
          width: size.width,
          height: size.height * 0.33 +
              ((theme.monthWeekDayHeaders) ? size.height * 0.04 : 0),
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
                dateTimePickerController: dateTimePickerController,
                dateTimePickerConfiguration: dateTimePickerConfiguration,
              ),
              MonthDateTimePicker(
                date: DateTime(
                  dateTimePickerController.browsingDate.year,
                  dateTimePickerController.browsingDate.month,
                  1,
                ),
                dateTimePickerController: dateTimePickerController,
                dateTimePickerConfiguration: dateTimePickerConfiguration,
                monthDateBoxSize: monthDateBoxSize,
              ),
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
                dateTimePickerConfiguration: dateTimePickerConfiguration,
                monthDateBoxSize: monthDateBoxSize,
              ),
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
