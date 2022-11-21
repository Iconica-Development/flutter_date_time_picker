// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter_date_time_picker/src/models/date_constraint.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Date Range', () {
    group('inRange()', () {
      test(
          'inRange() should return true when date is between min and max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 06, 01)),
          max: DateConstraint(date: DateTime(2022, 07, 01)),
        );
        expect(range.inRange(DateTime(2022, 06, 20)), true);
        expect(range.inRange(DateTime(2022, 07, 20)), false);
        expect(range.inRange(DateTime(2022, 05, 20)), false);
      });

      test(
          'inRange() should return true when date is between infinity and max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint.infinity,
          max: DateConstraint(date: DateTime(2022, 07, 01)),
        );
        expect(range.inRange(DateTime(2022, 06, 20)), true);
        expect(range.inRange(DateTime(2022, 07, 20)), false);
        expect(range.inRange(DateTime(2022, 05, 20)), true);
      });

      test(
          'inRange() should return true when date is between min and infinity otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 06, 01)),
          max: DateConstraint.infinity,
        );
        expect(range.inRange(DateTime(2022, 06, 20)), true);
        expect(range.inRange(DateTime(2022, 07, 20)), true);
        expect(range.inRange(DateTime(2022, 05, 20)), false);
      });

      test('inRange() should return true when date is lower then max', () {
        DateTimeConstraint range = DateTimeConstraint(
          max: DateConstraint(date: DateTime(2022, 07, 01)),
        );
        expect(range.inRange(DateTime(2022, 06, 20)), true);
        expect(range.inRange(DateTime(2022, 07, 20)), false);
        expect(range.inRange(DateTime(2022, 05, 20)), true);
      });

      test('inRange() should return true when date is higher then min', () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 06, 01)),
        );
        expect(range.inRange(DateTime(2022, 06, 20)), true);
        expect(range.inRange(DateTime(2022, 07, 20)), true);
        expect(range.inRange(DateTime(2022, 05, 20)), false);
      });

      test('inRange() should return true when date is equal to max', () {
        DateTimeConstraint range = DateTimeConstraint(
          max: DateConstraint(date: DateTime(2022, 06, 01)),
        );
        expect(range.inRange(DateTime(2022, 06, 01)), true);
        expect(range.inRange(DateTime(2022, 05, 30)), true);
        expect(range.inRange(DateTime(2022, 06, 02)), false);
      });

      test('inRange() should return true when date is equal to min', () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 06, 01)),
        );
        expect(range.inRange(DateTime(2022, 06, 01)), true);
        expect(range.inRange(DateTime(2022, 06, 02)), true);
        expect(range.inRange(DateTime(2022, 05, 30)), false);
      });
    });
    group('inYearRange()', () {
      test(
          'inYearRange() should return true when year is between min and max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 1, 1)),
          max: DateConstraint(date: DateTime(2024, 1, 1)),
        );
        expect(range.inYearRange(DateTime(2023, 1, 1)), true);
        expect(range.inYearRange(DateTime(2021, 1, 1)), false);
        expect(range.inYearRange(DateTime(2025, 1, 1)), false);
      });
      test(
          'inYearRange() should return true when year equals min or max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 1, 1)),
          max: DateConstraint(date: DateTime(2023, 1, 1)),
        );
        expect(range.inYearRange(DateTime(2022, 1, 1)), true);
        expect(range.inYearRange(DateTime(2023, 1, 1)), true);
        expect(range.inYearRange(DateTime(2021, 1, 1)), false);
        expect(range.inYearRange(DateTime(2024, 1, 1)), false);
      });
      test(
          'inYearRange() should return true when year is between min and infinity otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 1, 1)),
        );
        expect(range.inYearRange(DateTime(2023, 1, 1)), true);
        expect(range.inYearRange(DateTime(2025, 1, 1)), true);
        expect(range.inYearRange(DateTime(2021, 1, 1)), false);
      });
      test(
          'inYearRange() should return true when year is between infinity and max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          max: DateConstraint(date: DateTime(2024, 1, 1)),
        );
        expect(range.inYearRange(DateTime(2023, 1, 1)), true);
        expect(range.inYearRange(DateTime(2021, 1, 1)), true);
        expect(range.inYearRange(DateTime(2025, 1, 1)), false);
      });
    });
    group('inMonthRange()', () {
      test(
          'inMonthRange() should return true when year is between min and max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 5, 1)),
          max: DateConstraint(date: DateTime(2022, 7, 1)),
        );
        expect(range.inMonthRange(DateTime(2022, 6, 1)), true);
        expect(range.inMonthRange(DateTime(2022, 3, 1)), false);
        expect(range.inMonthRange(DateTime(2022, 8, 1)), false);
      });
      test(
          'inMonthRange() should return true when year equals min or max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 5, 1)),
          max: DateConstraint(date: DateTime(2022, 6, 1)),
        );
        expect(range.inMonthRange(DateTime(2022, 5, 1)), true);
        expect(range.inMonthRange(DateTime(2022, 6, 1)), true);
        expect(range.inMonthRange(DateTime(2022, 4, 1)), false);
        expect(range.inMonthRange(DateTime(2022, 7, 1)), false);
      });
      test(
          'inMonthRange() should return true when year is between min and infinity otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 5, 1)),
        );
        expect(range.inMonthRange(DateTime(2022, 6, 1)), true);
        expect(range.inMonthRange(DateTime(2022, 8, 1)), true);
        expect(range.inMonthRange(DateTime(2022, 3, 1)), false);
      });
      test(
          'inMonthRange() should return true when year is between infinity and max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          max: DateConstraint(date: DateTime(2022, 7, 1)),
        );
        expect(range.inMonthRange(DateTime(2022, 6, 1)), true);
        expect(range.inMonthRange(DateTime(2022, 3, 1)), true);
        expect(range.inMonthRange(DateTime(2022, 8, 1)), false);
      });
    });
    group('inDateRange()', () {
      test(
          'inDateRange() should return true when year is between min and max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 1, 4)),
          max: DateConstraint(date: DateTime(2022, 1, 6)),
        );
        expect(range.inDateRange(DateTime(2022, 1, 5)), true);
        expect(range.inDateRange(DateTime(2022, 1, 3)), false);
        expect(range.inDateRange(DateTime(2022, 1, 7)), false);
      });
      test(
          'inDateRange() should return true when year equals min or max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 1, 4)),
          max: DateConstraint(date: DateTime(2022, 1, 5)),
        );
        expect(range.inDateRange(DateTime(2022, 1, 4)), true);
        expect(range.inDateRange(DateTime(2022, 1, 5)), true);
        expect(range.inDateRange(DateTime(2022, 1, 3)), false);
        expect(range.inDateRange(DateTime(2022, 1, 6)), false);
      });
      test(
          'inDateRange() should return true when year is between min and infinity otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          min: DateConstraint(date: DateTime(2022, 1, 4)),
        );
        expect(range.inDateRange(DateTime(2022, 1, 5)), true);
        expect(range.inDateRange(DateTime(2022, 1, 7)), true);
        expect(range.inDateRange(DateTime(2022, 1, 3)), false);
      });
      test(
          'inDateRange() should return true when year is between infinity and max otherwise false',
          () {
        DateTimeConstraint range = DateTimeConstraint(
          max: DateConstraint(date: DateTime(2022, 1, 6)),
        );
        expect(range.inDateRange(DateTime(2022, 1, 5)), true);
        expect(range.inDateRange(DateTime(2022, 1, 3)), true);
        expect(range.inDateRange(DateTime(2022, 1, 7)), false);
      });
    });
  });
}
