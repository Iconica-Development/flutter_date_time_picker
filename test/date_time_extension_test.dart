import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';

void main() {
  group('DateTimeExtension', () {
    test('sameDayAs() should return true if the same date, if not false', () {
      expect(DateTime(2022, 01, 01).sameDayAs(DateTime(2022, 01, 01)), true);
      expect(DateTime(2022, 01, 01).sameDayAs(DateTime(2022, 01, 02)), false);
    });

    test(
        'dateContainedIn() should return a boolean if the date is found in a list of dates or not',
        () {
      expect(
          DateTime(2022, 01, 01).dateContainedIn([
            DateTime(2022, 01, 01),
            DateTime(2022, 01, 02),
            DateTime(2022, 01, 03)
          ]),
          true);

      expect(
          DateTime(2022, 01, 01).dateContainedIn([
            DateTime(2022, 01, 02),
            DateTime(2022, 01, 03),
            DateTime(2022, 01, 04)
          ]),
          false);
    });

    test(
        'isLeapYear should return a boolean if the given year is a leap year or not',
        () {
      expect(DateTime(2016, 01, 01).isLeapYear, true); // A leap year
      expect(DateTime(2017, 01, 01).isLeapYear, false); // Not a leap year
      expect(DateTime(2018, 01, 01).isLeapYear, false); // Not a leap year
      expect(DateTime(2019, 01, 01).isLeapYear, false); // Not a leap year
      expect(DateTime(2020, 01, 01).isLeapYear, true); // A leap year
    });

    test(
        'daysInMonth() should return the amount of days in the month relative on the date',
        () {
      var monthOfJanuary = DateTime(2022, 01, 01);
      var monthOfFebruary = DateTime(2022, 02, 01);
      var monthOfMarch = DateTime(2022, 03, 01);
      var monthOfApril = DateTime(2022, 04, 01);
      var monthOfMay = DateTime(2022, 05, 01);
      var monthOfJune = DateTime(2022, 06, 01);
      var monthOfJuly = DateTime(2022, 07, 01);
      var monthOfAugust = DateTime(2022, 08, 01);
      var monthOfSeptember = DateTime(2022, 09, 01);
      var monthOfOctober = DateTime(2022, 10, 01);
      var monthOfNovember = DateTime(2022, 11, 01);
      var monthOfDecember = DateTime(2022, 12, 01);

      expect(monthOfJanuary.daysInMonth(), 31);
      // 2022 is not a leap year so this should return 28
      expect(monthOfFebruary.daysInMonth(), 28);
      expect(monthOfMarch.daysInMonth(), 31);
      expect(monthOfApril.daysInMonth(), 30);
      expect(monthOfMay.daysInMonth(), 31);
      expect(monthOfJune.daysInMonth(), 30);
      expect(monthOfJuly.daysInMonth(), 31);
      expect(monthOfAugust.daysInMonth(), 31);
      expect(monthOfSeptember.daysInMonth(), 30);
      expect(monthOfOctober.daysInMonth(), 31);
      expect(monthOfNovember.daysInMonth(), 30);
      expect(monthOfDecember.daysInMonth(), 31);

      // 2020 is a leap year so this should return 29
      expect(DateTime(2020, 02, 01).daysInMonth(), 29);
    });
  });
}
