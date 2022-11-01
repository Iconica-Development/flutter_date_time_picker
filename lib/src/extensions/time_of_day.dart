// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  /// Check if the current [TimeOfDay] contains any the given [times]
  bool containsAny(List<TimeOfDay> times) {
    return times.any((element) => element.equals(this));
  }

  /// Check if the current [TimeOfDay] is the same as the given [selectedTime]
  bool equals(TimeOfDay selectedTime) {
    return selectedTime.hour == hour && selectedTime.minute == minute;
  }
}
