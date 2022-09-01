import 'package:flutter/widgets.dart' show Color, TextStyle;

class DateBoxHighlightTheme {
  /// Highlighted date theme.
  const DateBoxHighlightTheme(
    this.backgroundColor,
    this.textStyle,
  );

  /// Background color of highlighted date.
  final Color? backgroundColor;

  /// The style of the date number.
  final TextStyle? textStyle;
}
