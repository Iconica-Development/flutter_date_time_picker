// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class DateTimeConstraint {
  final DateConstraint min;
  final DateConstraint max;

  const DateTimeConstraint({
    this.min = DateConstraint.infinity,
    this.max = DateConstraint.infinity,
  });

  bool inRange(DateTime date) {
    return _checkDate(
          min,
          () => !date.isBefore(min.date!),
        ) &&
        _checkDate(
          max,
          () => !date.isAfter(max.date!),
        );
  }

  bool inDateRange(DateTime date) {
    return _checkDate(
          min,
          () => !_stripToDateOnly(date).isBefore(_stripToDateOnly(min.date!)),
        ) &&
        _checkDate(
          max,
          () => !_stripToDateOnly(date).isAfter(_stripToDateOnly(max.date!)),
        );
  }

  bool inMonthRange(DateTime date) {
    return _checkDate(
          min,
          () =>
              !_stripToMonthsOnly(date).isBefore(_stripToMonthsOnly(min.date!)),
        ) &&
        _checkDate(
          max,
          () =>
              !_stripToMonthsOnly(date).isAfter(_stripToMonthsOnly(max.date!)),
        );
  }

  bool inYearRange(DateTime date) {
    return _checkDate(
          min,
          () => !_stripToYearsOnly(date).isBefore(_stripToYearsOnly(min.date!)),
        ) &&
        _checkDate(
          max,
          () => !_stripToYearsOnly(date).isAfter(_stripToYearsOnly(max.date!)),
        );
  }

  DateTime _stripToDateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  DateTime _stripToMonthsOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      1,
    );
  }

  DateTime _stripToYearsOnly(DateTime date) {
    return DateTime(
      date.year,
      1,
      1,
    );
  }

  bool _checkDate(DateConstraint constraint, bool Function() checker) {
    if (!constraint.isInfinite) {
      return checker();
    }
    return constraint.isInfinite;
  }
}

class DateConstraint {
  static const DateConstraint infinity =
      DateConstraint(date: null, isInfinite: true);
  final DateTime? date;
  final bool isInfinite;

  const DateConstraint({this.date, this.isInfinite = false})
      : assert(
          !(date != null && isInfinite),
          'Can NOT have a limit set and be infinite.',
        ),
        assert(
          date != null || isInfinite,
          'Must set some form of a limit.',
        );
}
