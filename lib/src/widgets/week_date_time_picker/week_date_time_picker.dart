import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:intl/intl.dart';

class WeekDateTimePicker extends StatelessWidget {
  const WeekDateTimePicker({
    required this.dateTimePickerController,
    required this.date,
    Key? key,
  }) : super(key: key);

  final DateTimePickerController dateTimePickerController;

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        date.daysOfWeek().length,
        (index) => GestureDetector(
          onTap: () {
            dateTimePickerController.onTapDay(date.daysOfWeek()[index]);
          },
          child: SizedBox(
            width: 40,
            height: 60,
            child: Column(
              children: [
                const Spacer(),
                Text(
                  DateFormat.E()
                      .format(
                        date.daysOfWeek().elementAt(index),
                      )
                      .toUpperCase()[0],
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: shouldHighlight(index)
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          date.daysOfWeek().elementAt(index).day.toString(),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: shouldHighlight(index)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                        ),
                      ),
                      if (shouldMark(index)) ...[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Theme.of(context).indicatorColor,
                              borderRadius: BorderRadius.circular(45),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool shouldHighlight(int index) {
    return date.daysOfWeek().elementAt(index).sameDayAs(
          dateTimePickerController.highlightToday
              ? DateTime.now()
              : dateTimePickerController.selectedDate,
        );
  }

  bool isSelected(int index) {
    return date
        .daysOfWeek()
        .elementAt(index)
        .sameDayAs(dateTimePickerController.selectedDate);
  }

  bool shouldMark(int index) {
    return !date.daysOfWeek().elementAt(index).sameDayAs(
              dateTimePickerController.highlightToday
                  ? DateTime.now()
                  : dateTimePickerController.selectedDate,
            ) &&
        date
            .daysOfWeek()
            .elementAt(index)
            .isContainedIn(dateTimePickerController.markedDates ?? []);
  }
}
