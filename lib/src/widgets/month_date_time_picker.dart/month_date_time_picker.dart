import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';

class MonthDateTimePicker extends StatelessWidget {
  const MonthDateTimePicker({
    required this.date,
    required this.dateTimePickerController,
    Key? key,
  }) : super(key: key);

  final DateTime date;
  final DateTimePickerController dateTimePickerController;

  @override
  Widget build(BuildContext context) {
    int daysToSkip = DateTime(
      date.year,
      date.month,
      0,
      12,
    ).weekday;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Center(
        child: Wrap(
          spacing: 10,
          children: List.generate(
            DateTime(date.year, date.month).getDaysInMonth() + daysToSkip,
            (index) {
              if (index < daysToSkip) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.4),
                      border: Border.all(color: Colors.black, width: 1.5)),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: 45,
                  width: 45,
                  child: Center(
                    child: Text(
                      (index + 1 - daysToSkip).toString(),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ),
                );
              }

              return GestureDetector(
                onTap: () async {
                  // await dateTimePickerController.getDragController().animateTo(
                  //       0.26,
                  //       duration: const Duration(
                  //         milliseconds: 350,
                  //       ),
                  //       curve: Curves.ease,
                  //     );

                  dateTimePickerController.onTapDay(DateTime(
                    date.year,
                    date.month,
                    index + 1 - daysToSkip,
                    date.hour,
                    date.minute,
                    date.second,
                  ));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color:
                        // isSelected(index, daysToSkip)
                        shouldHighlight(index, daysToSkip)
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  height: 45,
                  width: 45,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          (index + 1 - daysToSkip).toString(),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color:
                                        // isSelected(index, daysToSkip)
                                        shouldHighlight(index, daysToSkip)
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                        ),
                      ),
                      if (shouldMark(index, daysToSkip)) ...[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 12,
                            height: 12,
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
    ).isSameDayAs(
      dateTimePickerController.highlightToday
          ? DateTime.now()
          : dateTimePickerController.selectedDate,
    );
  }

  bool isSelected(int index, int daysToSkip) {
    return DateTime(
      date.year,
      date.month,
      index + 1 - daysToSkip,
    ).isSameDayAs(dateTimePickerController.selectedDate);
  }

  bool shouldMark(int index, int daysToSkip) {
    return !DateTime(
          date.year,
          date.month,
          index + 1 - daysToSkip,
        ).isSameDayAs(
          dateTimePickerController.highlightToday
              ? DateTime.now()
              : dateTimePickerController.selectedDate,
        ) &&
        DateTime(
          date.year,
          date.month,
          index + 1 - daysToSkip,
        ).isDayPartOf(
          dateTimePickerController.markedDates ?? [],
        );
  }
}
