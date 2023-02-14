// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/widgets.dart' show Color, TextStyle, BoxBorder;

class DateBoxTheme {
  /// Default date theme.
  const DateBoxTheme({
    this.backgroundColor,
    this.textStyle,
    this.borderStyle,
  });

  /// Background color of default date
  final Color? backgroundColor;

  /// The style of the date number.
  final TextStyle? textStyle;

  /// The style of the border
  final BoxBorder? borderStyle;
}
