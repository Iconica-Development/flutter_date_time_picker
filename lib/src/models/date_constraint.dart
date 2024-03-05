// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

/// Class representing date constraints for DateTime values.
class DateTimeConstraint {
  /// Minimum date constraint.
  final DateConstraint min;

  /// Maximum date constraint.
  final DateConstraint max;

  /// Constructs a DateTimeConstraint instance.
  const DateTimeConstraint({
    this.min = DateConstraint.infinity,
    this.max = DateConstraint.infinity,
  });

  /// Checks if the given date is within the range specified by min and max constraints.
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

  /// Checks if the given date is within the date range (ignoring time) specified by min and max constraints.
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

  /// Checks if the given date is within the month range specified by min and max constraints.
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

  /// Checks if the given date is within the year range specified by min and max constraints.
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

  /// Strips the given date to date only (no time information).
  DateTime _stripToDateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  /// Strips the given date to month only.
  DateTime _stripToMonthsOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      1,
    );
  }

  /// Strips the given date to year only.
  DateTime _stripToYearsOnly(DateTime date) {
    return DateTime(
      date.year,
      1,
      1,
    );
  }

  /// Checks if the date constraint is met.
  bool _checkDate(DateConstraint constraint, bool Function() checker) {
    if (!constraint.isInfinite) {
      return checker();
    }
    return constraint.isInfinite;
  }
}

/// Class representing a date constraint.
class DateConstraint {
  /// Date constraint representing infinity.
  static const DateConstraint infinity =
      DateConstraint(date: null, isInfinite: true);

  /// The date associated with the constraint.
  final DateTime? date;

  /// Indicates if the constraint is infinite.
  final bool isInfinite;

  /// Constructs a DateConstraint instance.
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
