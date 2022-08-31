import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/extensions/time_of_day.dart';
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
          late Map<String, Color> calendarColors;

          calendarColors = determineColors(
            context,
            index,
          );
          return GestureDetector(
            onTap: isDisabled(
              index,
            )
                ? null
                : () async {
                    TimeOfDay? timeOfDay;
                    // await dateTimePickerController.getDragController().animateTo(
                    //       0.26,
                    //       duration: const Duration(
                    //         milliseconds: 350,
                    //       ),
                    //       curve: Curves.ease,
                    //     );

                    DateTime selectedDate = date.daysOfWeek()[index];

                    if (dateTimePickerController.pickTime) {
                      timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat:
                                      dateTimePickerController
                                          .alwaysUse24HourFormat),
                              child: child!,
                            );
                          });
                    }

                    if (timeOfDay != null &&
                        timeOfDay.timeContainedIn(
                            dateTimePickerController.disabledTimes ?? [])) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Verkeerde tijd gekozen'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text(
                                        'De tijd die u wilt kiezen, is niet mogelijk, makke een andere keuze.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    } else {
                      timeOfDay = TimeOfDay(hour: 0, minute: 0);
                    }

                    DateTime selectedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      timeOfDay.hour,
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
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: calendarColors['backgroundColor'],
                      borderRadius:
                          _determineBorderRadius(dateTimePickerController),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            date.daysOfWeek().elementAt(index).day.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: calendarColors['textColor']),
                          ),
                        ),
                        if (shouldMark(index)) ...[
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: weekDateBoxSize,
                              height: weekDateBoxSize,
                              decoration: BoxDecoration(
                                color: Theme.of(context).indicatorColor,
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

  determineColors(context, index) {
    Map<String, Color> calendarColors = {
      'backgroundColor': Colors.transparent,
      'textColor': Colors.black
    };

    if (isDisabled(index)) {
      calendarColors = {
        'backgroundColor': Theme.of(context).disabledColor,
        'textColor': Colors.white
      };
    }
    if (isSelected(index)) {
      calendarColors = {
        'backgroundColor': Theme.of(context).primaryColor.withOpacity(0.3),
        'textColor': Theme.of(context).primaryColor
      };
    }
    if (shouldHighlight(index)) {
      calendarColors = {
        'backgroundColor': Theme.of(context).primaryColor,
        'textColor': Colors.white
      };
    }

    return calendarColors;
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

  bool isDisabled(int index) {
    return date
        .daysOfWeek()
        .elementAt(index)
        .dateContainedIn(dateTimePickerController.disabledDates ?? []);
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
            .dateContainedIn(dateTimePickerController.markedDates ?? []);
  }

  BorderRadius _determineBorderRadius(
      DateTimePickerController dateTimePickerController) {
    switch (dateTimePickerController.dateBoxShape) {
      case DateBoxShape.circle:
        return BorderRadius.circular(weekDateBoxSize * 2);
      case DateBoxShape.rectangle:
        return BorderRadius.zero;
      case DateBoxShape.roundedRectangle:
        return BorderRadius.circular(weekDateBoxSize / 4.5);
    }
  }
}
