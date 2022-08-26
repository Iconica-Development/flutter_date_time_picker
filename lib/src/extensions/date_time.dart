extension DatePickerUtil on DateTime {
  bool isSameDayAs(DateTime selectedDate) {
    return selectedDate.day == day &&
        selectedDate.month == month &&
        selectedDate.year == year;
  }

  bool isDayPartOf(List<DateTime> dates) {
    return dates.any((element) => element.isSameDayAs(this));
  }

  List<DateTime> getDaysOfWeek() {
    var startFrom = subtract(Duration(days: weekday));
    return List.generate(
      7,
      (i) => startFrom.add(
        Duration(days: i + 1),
      ),
    );
  }

  int getDaysInMonth() {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }

    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];

    return daysInMonth[month - 1];
  }
}