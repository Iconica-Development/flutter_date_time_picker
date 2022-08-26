import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/month_date_time_picker.dart/month_date_time_picker.dart';
import 'package:intl/intl.dart';

class MonthDateTimePickerSheet extends StatelessWidget {
  const MonthDateTimePickerSheet({
    required this.dateTimePickerController,
    Key? key,
  }) : super(key: key);

  final DateTimePickerController dateTimePickerController;

  @override
  Widget build(BuildContext context) {
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
          DateFormat("MMMM yyyy").format(
            dateTimePickerController.browsingDate,
          ),
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.black),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: PageView(
            controller: dateTimePickerController.getPageController(),
            onPageChanged: (i) {
              if (i == 0) {
                dateTimePickerController.onPageChanged(
                  dateTimePickerController.browsingDate.subtract(
                    Duration(
                      days: DateTime(dateTimePickerController.browsingDate.year,
                              dateTimePickerController.browsingDate.month)
                          .getDaysInMonth(),
                    ),
                  ),
                );
              } else if (i == 2) {
                dateTimePickerController.onPageChanged(
                  dateTimePickerController.browsingDate.add(
                    Duration(
                      days: DateTime(dateTimePickerController.browsingDate.year,
                              dateTimePickerController.browsingDate.month)
                          .getDaysInMonth(),
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
                  dateTimePickerController: dateTimePickerController),
              MonthDateTimePicker(
                  date: dateTimePickerController.browsingDate,
                  dateTimePickerController: dateTimePickerController),
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
              ),
            ],
          ),
        ),
        Container(
          height: 3,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
