import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/extensions/time_of_day.dart';
import 'package:flutter_date_time_picker/src/models/date_box_current_theme.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:intl/intl.dart';

class WeekDateTimePicker extends StatelessWidget {
  const WeekDateTimePicker({
    required this.dateTimePickerController,
    required this.date,
    required this.weekDateBoxSize,
    Key? key,
  }) : super(key: key);

  final DateTimePickerController dateTimePickerController;

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
              context, index, dateTimePickerController.theme);
          return GestureDetector(
            onTap: isDisabled(
              index,
            )
                ? null
                : () async {
                    TimeOfDay? timeOfDay;

                    DateTime selectedDate = date.daysOfWeek()[index];

                    timeOfDay = const TimeOfDay(hour: 0, minute: 0);

                    if (dateTimePickerController.pickTime) {
                      timeOfDay = await displayTimePicker(
                          context, dateTimePickerController);
                    }

                    if (dateTimePickerController.wrongTimeDialog != null) {
                      if (timeOfDay != null &&
                          timeOfDay.containsAny(
                            dateTimePickerController.disabledTimes ?? [],
                          )) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              dateTimePickerController.wrongTimeDialog!,
                        );
                      }
                    }

                    DateTime selectedDateTime = DateTime(
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
                    DateFormat.E()
                        .format(
                          date.daysOfWeek().elementAt(index),
                        )
                        .toUpperCase()[0],
                    style: dateTimePickerController.theme.baseTheme.textStyle,
                  ),
                  const Spacer(),
                  Container(
                    height: weekDateBoxSize,
                    width: weekDateBoxSize,
                    decoration: BoxDecoration(
                      color: currentDateBoxTheme.backgroundColor,
                      borderRadius:
                          _determineBorderRadius(dateTimePickerController),
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
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: weekDateBoxSize / 3,
                              height: weekDateBoxSize / 3,
                              decoration: BoxDecoration(
                                color: dateTimePickerController
                                        .theme.markedIndicatorColor ??
                                    Theme.of(context).indicatorColor,
                                borderRadius:
                                    BorderRadius.circular(weekDateBoxSize * 2),
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
          dateTimePickerController.highlightToday
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
        .containsAny(dateTimePickerController.disabledDates ?? []);
  }

  bool shouldMark(int index) {
    return !date.daysOfWeek().elementAt(index).equals(
              dateTimePickerController.highlightToday
                  ? DateTime.now()
                  : dateTimePickerController.selectedDate,
            ) &&
        date
            .daysOfWeek()
            .elementAt(index)
            .containsAny(dateTimePickerController.markedDates ?? []);
  }

  BorderRadius _determineBorderRadius(
      DateTimePickerController dateTimePickerController) {
    switch (dateTimePickerController.theme.dateBoxShape) {
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
                    dateTimePickerController.alwaysUse24HourFormat),
            child: child!,
          );
        });
  }
}
