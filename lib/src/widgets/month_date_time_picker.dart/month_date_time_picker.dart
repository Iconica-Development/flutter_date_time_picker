import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/enums/date_box_shape.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/extensions/time_of_day.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';

class MonthDateTimePicker extends StatelessWidget {
  const MonthDateTimePicker({
    required this.date,
    required this.dateTimePickerController,
    required this.monthDateBoxSize,
    Key? key,
  }) : super(key: key);

  final DateTime date;
  final DateTimePickerController dateTimePickerController;
  final double monthDateBoxSize;

  @override
  Widget build(BuildContext context) {
    int daysToSkip = DateTime(
      date.year,
      date.month,
      0,
      12,
    ).weekday;

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 5,
          crossAxisCount: 7,
          children: List.generate(
            DateTime(date.year, date.month).daysInMonth() +
                (daysToSkip >= 7 ? 0 : daysToSkip),
            (index) {
              late Map<String, Color> calendarColors;

              int addedIndex = index;

              if (daysToSkip >= 7) {
                addedIndex = index + 7;
              }
              if (addedIndex < daysToSkip) {
                return const SizedBox.shrink();
              }

              calendarColors = determineColors(
                context,
                addedIndex,
                daysToSkip,
              );

              return GestureDetector(
                onTap: isDisabled(
                  addedIndex,
                  daysToSkip,
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

                        DateTime selectedDate = DateTime(
                          date.year,
                          date.month,
                          addedIndex + 1 - daysToSkip,
                        );

                        if (dateTimePickerController.pickTime) {
                          timeOfDay = await displayTimePicker(
                              context, dateTimePickerController);
                        }

                        if (timeOfDay != null &&
                            timeOfDay.timeContainedIn(
                                dateTimePickerController.disabledTimes ?? [])) {
                        } else {
                          timeOfDay = const TimeOfDay(hour: 0, minute: 0);
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
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: calendarColors['backgroundColor'],
                    borderRadius:
                        _determineBorderRadius(dateTimePickerController),
                  ),
                  height: 45,
                  width: 45,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          (addedIndex + 1 - daysToSkip).toString(),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: calendarColors['textColor'],
                                  ),
                        ),
                      ),
                      if (shouldMark(
                        addedIndex,
                        daysToSkip,
                      )) ...[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IgnorePointer(
                            child: Container(
                              width: monthDateBoxSize / 4,
                              height: monthDateBoxSize / 4,
                              decoration: BoxDecoration(
                                color: Theme.of(context).indicatorColor,
                                borderRadius: BorderRadius.circular(
                                    (monthDateBoxSize / 4) * 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool shouldHighlight(int index, int daysToSkip) {
    return DateTime(
      date.year,
      date.month,
      index + 1 - daysToSkip,
    ).sameDayAs(
      dateTimePickerController.highlightToday
          ? DateTime.now()
          : dateTimePickerController.selectedDate,
    );
  }

  determineColors(context, index, daysToSkip) {
    Map<String, Color> calendarColors = {
      'backgroundColor': Colors.transparent,
      'textColor': Colors.black
    };

    if (isDisabled(index, daysToSkip)) {
      calendarColors = {
        'backgroundColor': Theme.of(context).disabledColor,
        'textColor': Colors.white
      };
    }
    if (isSelected(index, daysToSkip)) {
      calendarColors = {
        'backgroundColor': Theme.of(context).primaryColor.withOpacity(0.3),
        'textColor': Theme.of(context).primaryColor
      };
    }
    if (shouldHighlight(index, daysToSkip)) {
      calendarColors = {
        'backgroundColor': Theme.of(context).primaryColor,
        'textColor': Colors.white
      };
    }

    return calendarColors;
  }

  bool isDisabled(int index, int daysToSkip) {
    return DateTime(
      date.year,
      date.month,
      index + 1 - daysToSkip,
    ).dateContainedIn(
      dateTimePickerController.disabledDates ?? [],
    );
  }

  bool isSelected(int index, int daysToSkip) {
    return DateTime(
      date.year,
      date.month,
      index + 1 - daysToSkip,
    ).sameDayAs(dateTimePickerController.selectedDate);
  }

  bool shouldMark(int index, int daysToSkip) {
    return !DateTime(
          date.year,
          date.month,
          index + 1 - daysToSkip,
        ).sameDayAs(
          dateTimePickerController.highlightToday
              ? DateTime.now()
              : dateTimePickerController.selectedDate,
        ) &&
        DateTime(
          date.year,
          date.month,
          index + 1 - daysToSkip,
        ).dateContainedIn(
          dateTimePickerController.markedDates ?? [],
        );
  }

  BorderRadius _determineBorderRadius(
      DateTimePickerController dateTimePickerController) {
    switch (dateTimePickerController.dateBoxShape) {
      case DateBoxShape.circle:
        return BorderRadius.circular(monthDateBoxSize * 2);
      case DateBoxShape.rectangle:
        return BorderRadius.zero;
      case DateBoxShape.roundedRectangle:
        return BorderRadius.circular(monthDateBoxSize / 4.5);
    }
  }
}

class WrongTimeDialog extends StatelessWidget {
  const WrongTimeDialog({required this.dateTimePickerController, Key? key})
      : super(key: key);

  final DateTimePickerController dateTimePickerController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Verkeerde tijd gekozen'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text(
                'De tijd die u wilt kiezen, is niet mogelijk, maak een andere keuze.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            displayTimePicker(context, dateTimePickerController);
          },
        ),
      ],
    );
  }
}

displayTimePicker(BuildContext context,
    DateTimePickerController dateTimePickerController) async {
  await showTimePicker(
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
