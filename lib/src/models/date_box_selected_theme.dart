// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/widgets.dart' show Color, TextStyle;

class DateBoxSelectedTheme {
  /// Selected date theme.
  const DateBoxSelectedTheme(
    this.backgroundColor,
    this.textStyle,
  );

  /// Background color of selected date.
  final Color? backgroundColor;

  /// The style of the date number.
  final TextStyle? textStyle;
}
