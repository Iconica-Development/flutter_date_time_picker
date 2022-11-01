// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

extension DateTimeExtension on DateTime {
  /// Check if the current [DateTime] is the same as the given [selectedDate]
  bool equals(DateTime selectedDate) {
    return selectedDate.day == day &&
        selectedDate.month == month &&
        selectedDate.year == year;
  }

  /// Check if the current [DateTime] contains any the given [dates]
  bool containsAny(List<DateTime> dates) {
    return dates.any((element) => element.equals(this));
  }

  // Return a [List] of [DateTime] objects of the week the current [DateTime] is in.
  List<DateTime> daysOfWeek() {
    var startFrom = subtract(Duration(days: weekday));
    return List.generate(
      7,
      (i) => startFrom.add(
        Duration(days: i + 1),
      ),
      growable: false,
    );
  }

  /// Determine if a certain [year] of a [DateTime] object is a leap year.
  bool get isLeapYear =>
      (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);

  /// Returns the amount of days in the current month of the [DateTime] object
  int daysInMonth() {
    late int amountOfDays;

    switch (month) {
      case DateTime.january:
      case DateTime.march:
      case DateTime.may:
      case DateTime.july:
      case DateTime.august:
      case DateTime.october:
      case DateTime.december:
        amountOfDays = 31;
        break;
      case DateTime.april:
      case DateTime.june:
      case DateTime.september:
      case DateTime.november:
        amountOfDays = 30;
        break;
      case DateTime.february:
        amountOfDays = isLeapYear ? 29 : 28;
        break;
    }

    return amountOfDays;
  }
}
