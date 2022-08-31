extension DateTimeExtension on DateTime {
  // Check if the current date is the same as the given date
  bool sameDayAs(DateTime selectedDate) {
    return selectedDate.day == day &&
        selectedDate.month == month &&
        selectedDate.year == year;
  }

  // Check if the current date is contained in the given list
  bool dateContainedIn(List<DateTime> dates) {
    return dates.any((element) => element.sameDayAs(this));
  }

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

  bool get isLeapYear =>
      (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);

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
