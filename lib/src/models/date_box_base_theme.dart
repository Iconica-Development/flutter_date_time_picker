import 'package:flutter/widgets.dart' show Color, TextStyle;

class DateBoxBaseTheme {
  /// Default date theme.
  const DateBoxBaseTheme(
    this.backgroundColor,
    this.textStyle,
  );

  /// Background color of default date
  final Color? backgroundColor;

  /// The style of the date number.
  final TextStyle? textStyle;
}
