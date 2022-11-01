// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/extensions/time_of_day.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeOfDayExtension', () {
    test('equals() should return true if the same time, if not false', () {
      expect(
          const TimeOfDay(hour: 12, minute: 0)
              .equals(const TimeOfDay(hour: 12, minute: 0)),
          true);
      expect(
          const TimeOfDay(hour: 13, minute: 0)
              .equals(const TimeOfDay(hour: 12, minute: 0)),
          false);
    });

    test(
        'containsAny() should return a boolean if the time is found in a list of times or not',
        () {
      expect(
          const TimeOfDay(hour: 12, minute: 0).containsAny(const [
            TimeOfDay(hour: 10, minute: 0),
            TimeOfDay(hour: 11, minute: 0),
            TimeOfDay(hour: 12, minute: 0)
          ]),
          true);

      expect(
          const TimeOfDay(hour: 12, minute: 0).containsAny(const [
            TimeOfDay(hour: 9, minute: 0),
            TimeOfDay(hour: 10, minute: 0),
            TimeOfDay(hour: 11, minute: 0)
          ]),
          false);
    });
  });
}
