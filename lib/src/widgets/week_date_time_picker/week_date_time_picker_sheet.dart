import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/week_date_time_picker/week_date_time_picker.dart';
import 'package:intl/intl.dart';

class WeekDateTimePickerSheet extends StatelessWidget {
  const WeekDateTimePickerSheet({
    required this.dateTimePickerController,
    this.showHeader = false,
    Key? key,
  }) : super(key: key);

  final DateTimePickerController dateTimePickerController;
  final bool showHeader;

  String getDateHeader() {
    List<DateTime> weekDays =
        dateTimePickerController.browsingDate.getDaysOfWeek();

    String firstDay = weekDays.first.day.toString();

    String lastDay = weekDays.last.day.toString();

    String monthYear =
        DateFormat("MMMM, yyyy").format(dateTimePickerController.browsingDate);

    return '$firstDay - $lastDay $monthYear';
  }

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
        if (showHeader) ...[
          Text(
            getDateHeader(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: PageView(
            controller: dateTimePickerController.getPageController(),
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
              ),
              WeekDateTimePicker(
                dateTimePickerController: dateTimePickerController,
                date: dateTimePickerController.browsingDate,
              ),
              WeekDateTimePicker(
                dateTimePickerController: dateTimePickerController,
                date: dateTimePickerController.browsingDate.add(
                  const Duration(days: 7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
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
