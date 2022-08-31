import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  bool timeContainedIn(List<TimeOfDay> times) {
    return times.any((element) => element.sameTimeAs(this));
  }

  bool sameTimeAs(TimeOfDay selectedTime) {
    return selectedTime.hour == hour && selectedTime.minute == minute;
  }
}
