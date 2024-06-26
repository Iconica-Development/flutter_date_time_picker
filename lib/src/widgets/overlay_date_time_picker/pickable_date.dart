// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_date_time_picker/src/widgets/marked_icon.dart';

/// `PickableDate` is a StatelessWidget that represents a selectable date.
/// It provides visual feedback based on its state (marked, selected, disabled, etc.).
class PickableDate extends StatelessWidget {
  /// Creates a new instance of `PickableDate`.
  ///
  /// The [isMarked], [isSelected], [isDisabled], [isToday], [isOffMonth], [date], [theme], and [onPressed] parameters must not be null.
  ///
  /// * [isMarked]: Indicates whether the date is marked.
  /// * [isSelected]: Indicates whether the date is selected.
  /// * [isDisabled]: Indicates whether the date is disabled.
  /// * [isToday]: Indicates whether the date is the current date.
  /// * [isOffMonth]: Indicates whether the date is in the off-month.
  /// * [date]: The date that this widget represents.
  /// * [theme]: The theme used for styling the widget.
  /// * [onPressed]: The callback that is called when the date is pressed.
  const PickableDate({
    super.key,
    required this.isMarked,
    required this.isSelected,
    required this.isDisabled,
    required this.theme,
    required this.onPressed,
    required this.date,
    required this.isOffMonth,
    required this.isToday,
  });

  final bool isMarked;
  final bool isSelected;
  final bool isDisabled;
  final bool isToday;
  final bool isOffMonth;
  final DateTime date;
  final DateTimePickerTheme theme;
  final void Function(DateTime date) onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isDisabled) return;
        onPressed.call(date);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: getBorder(
                isToday,
                isSelected,
              ),
              color: getColor(
                isToday,
                isSelected,
              ),
              borderRadius: getBorderRadius(theme.dateBoxShape),
            ),
            child: Center(
              child: Opacity(
                opacity: (isDisabled || isOffMonth) ? 0.5 : 1,
                child: Text(
                  date.day.toString(),
                  style: getStyle(
                    isToday,
                    isSelected,
                  ),
                ),
              ),
            ),
          ),
          if (isMarked) ...[
            if (theme.useMarkedTheme) ...[
              Container(
                decoration: BoxDecoration(
                  border: getMarkedBorder(
                    isMarked,
                  ),
                  color: getMarkedColor(
                    isMarked,
                  ),
                  borderRadius: getBorderRadius(theme.dateBoxShape),
                ),
                child: Center(
                  child: Opacity(
                    opacity: (isDisabled || isOffMonth) ? 0.5 : 1,
                    child: Text(
                      date.day.toString(),
                      style: getMarkedStyle(
                        isMarked,
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              MarkedIcon(
                color: theme.markedIndicatorColor,
                width: theme.monthDateBoxSize / 4,
                height: theme.monthDateBoxSize / 4,
              ),
            ]
          ],
        ],
      ),
    );
  }

  BorderRadiusGeometry? getBorderRadius(DateBoxShape shape) {
    switch (shape) {
      case DateBoxShape.circle:
        return BorderRadius.all(Radius.circular(theme.monthDateBoxSize));
      case DateBoxShape.roundedRectangle:
        return const BorderRadius.all(Radius.circular(10));
      case DateBoxShape.rectangle:
        return null;
    }
  }

  Color? getColor(bool isToday, bool isSelected) {
    if (isSelected) return theme.selectedTheme.backgroundColor;
    if (isToday) return theme.highlightTheme.backgroundColor;
    return null;
  }

  TextStyle? getStyle(bool isToday, bool isSelected) {
    if (isToday) return theme.highlightTheme.textStyle;
    if (isSelected) return theme.selectedTheme.textStyle;
    return theme.baseTheme.textStyle;
  }

  BoxBorder getBorder(bool isToday, bool isSelected) {
    if (isToday) {
      if (theme.highlightTheme.borderStyle != null) {
        return theme.highlightTheme.borderStyle!;
      }
    }
    if (isSelected) {
      if (theme.selectedTheme.borderStyle != null) {
        return theme.selectedTheme.borderStyle!;
      }
    }
    return Border.all(color: const Color.fromARGB(0, 255, 255, 255));
  }

  Color? getMarkedColor(bool isMarked) {
    if (isMarked) return theme.markedTheme.backgroundColor;
    return null;
  }

  TextStyle? getMarkedStyle(bool isMarked) {
    if (isMarked) return theme.markedTheme.textStyle;
    return theme.baseTheme.textStyle;
  }

  BoxBorder getMarkedBorder(bool isMarked) {
    if (isMarked) {
      if (theme.markedTheme.borderStyle != null) {
        return theme.markedTheme.borderStyle!;
      }
    }
    return Border.all(color: const Color.fromARGB(0, 255, 255, 255));
  }
}
