// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/extensions/date_time.dart';
import 'package:flutter_date_time_picker/src/models/date_time_picker_theme.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/models/date_constraint.dart';
import 'package:flutter_date_time_picker/src/widgets/overlay_date_time_picker/overlay.dart';

class OverlayDateTimePicker extends StatefulWidget {
  const OverlayDateTimePicker({
    this.theme = const DateTimePickerTheme(),
    this.textStyle = const TextStyle(),
    this.alignment = Alignment.bottomRight,
    this.initialDate,
    this.size = const Size(325, 375),
    this.onTapDay,
    this.highlightToday = true,
    this.alwaysUse24HourFormat = true,
    this.pickTime = false,
    this.markedDates,
    this.disabledDates,
    this.disabledTimes,
    this.child,
    super.key,
    this.buttonBuilder,
    this.closeOnSelectDate = true,
    this.showWeekDays = true,
    this.dateTimeConstraint = const DateTimeConstraint(),
    this.onNextPageButtonBuilder,
    this.onPreviousPageButtonBuilder,
  }) : assert(child != null || buttonBuilder != null);

  /// The child contained by the DatePicker.
  final Widget? child;

  /// Visual properties for the [OverlayDateTimePicker]
  final DateTimePickerTheme theme;

  /// Style to base the text on
  final TextStyle textStyle;

  /// Callback that provides the date tapped on as a [DateTime] object.
  final Function(DateTime date)? onTapDay;

  /// Whether the current day should be highlighted in the [OverlayDateTimePicker]
  final bool highlightToday;

  /// a [bool] to set de clock on [TimePickerDialog] to a fixed 24 or 12-hour format.
  final bool alwaysUse24HourFormat;

  /// is a [bool] that determines if the user is able to pick a time after picking a date using the [TimePickerDialog].
  final bool pickTime;

  /// indicates the starting date. Default is [DateTime.now()]
  final DateTime? initialDate;

  /// contain the dates [DateTime] that will be marked in the [OverlayDateTimePicker] by a small dot.
  final List<DateTime>? markedDates;

  /// a [List] of [DateTime] objects that will be disabled and cannot be interacted with whatsoever.
  final List<DateTime>? disabledDates;

  /// a [List] of [TimeOfDay] objects that cannot be picked in the [TimePickerDialog].
  final List<TimeOfDay>? disabledTimes;

  /// an [Alignment] to align the overlay relative to the button
  final Alignment alignment;

  /// a [Size] that indicates the size of the overlay
  final Size size;

  /// [buttonBuilder] is a method for building the button that can trigger the overlay to appear
  final Widget Function(Key key, void Function() onPressed)? buttonBuilder;

  /// is a [bool] that indicates if the overlay should be closed if a date has been picked.
  final bool closeOnSelectDate;

  /// [showWeekDays] is a [bool] that determines if day in the week indicators should be shown
  final bool showWeekDays;

  /// a [DateTimeConstraint] that dictates the constraints of the dates that can be picked.
  final DateTimeConstraint dateTimeConstraint;

  /// a [Function] that determents the icon of the button for going to the next page
  final Widget Function(void Function()? onPressed)? onNextPageButtonBuilder;

  /// a [Function] that determents the icon of the button for going to the previous page
  final Widget Function(void Function()? onPressed)?
      onPreviousPageButtonBuilder;

  @override
  State<OverlayDateTimePicker> createState() => _OverlayDateTimePickerState();
}

class _OverlayDateTimePickerState extends State<OverlayDateTimePicker> {
  final GlobalKey buttonKey = GlobalKey(
    debugLabel: "Overlay Date Time Picker - Button",
  );

  bool _isShown = false;

  late OverlayState? _overlayState;

  late final OverlayEntry _overlay = OverlayEntry(
    builder: (context) {
      var box = buttonKey.currentContext?.findRenderObject() as RenderBox;
      var offset = _calculateOffset(
        alignment: widget.alignment,
        position: box.localToGlobal(
          const Offset(0, 0),
        ),
        buttonSize: box.size,
        overlaySize: widget.size,
      );
      return Positioned(
        top: offset.dy,
        left: offset.dx,
        child: Material(
          color: Colors.transparent,
          child: _buildOverlay(context),
        ),
      );
    },
  );
  late final DateTimePickerController _dateTimePickerController =
      DateTimePickerController(
    highlightToday: widget.highlightToday,
    alwaysUse24HourFormat: widget.alwaysUse24HourFormat,
    pickTime: widget.pickTime,
    theme: widget.theme,
    markedDates: widget.markedDates,
    disabledDates: widget.disabledDates,
    disabledTimes: widget.disabledTimes,
    onTapDayCallBack: (date) {
      widget.onTapDay?.call(date);
      if (widget.closeOnSelectDate) {
        _toggleOverlay();
      }
    },
    browsingDate: widget.initialDate ?? DateTime.now(),
    selectedDate: widget.initialDate ?? DateTime.now(),
  );

  @override
  void dispose() {
    if (_overlay.mounted) _overlay.remove();
    _overlay.dispose();
    _overlayState = null;
    _dateTimePickerController.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    if (mounted && (_overlayState?.mounted ?? false)) {
      setState(() {
        if (!_isShown) {
          _overlayState?.insert(_overlay);
        } else {
          _overlay.remove();
        }
        _isShown = !_isShown;
      });
    }
  }

  Offset _calculateOffset({
    required Alignment alignment,
    required Offset position,
    required Size buttonSize,
    required Size overlaySize,
  }) {
    double offsetX = 0;
    double offsetY = 0;

    offsetX = position.dx + // adds the world x position of the button
        buttonSize.width *
            0.5 - // centers the pivot of the button of the calculation to the center of the button
        overlaySize.width *
            0.5 + // centers the pivot of the overlay of the calculation to the center of the overlay
        (overlaySize.width + buttonSize.width) * 0.5 * alignment.x;
    offsetY = position.dy + // adds the world y position of the button
        buttonSize.height * 0.5 -
        overlaySize.height * 0.5 +
        (overlaySize.height + buttonSize.height) * 0.5 * alignment.y;

    return Offset(offsetX, offsetY);
  }

  @override
  Widget build(BuildContext context) {
    _overlayState = Overlay.of(context);

    if (widget.buttonBuilder != null) {
      return widget.buttonBuilder!.call(
        buttonKey,
        () {
          _toggleOverlay();
        },
      );
    }
    return ElevatedButton(
        key: buttonKey,
        onPressed: () {
          _toggleOverlay();
        },
        child: widget.child);
  }

  Widget _buildOverlay(BuildContext context) {
    return Container(
      decoration: (widget.theme.shapeBorder == null)
          ? BoxDecoration(
              color: widget.theme.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
            )
          : ShapeDecoration(
              shape: widget.theme.shapeBorder!,
              color: widget.theme.backgroundColor,
              shadows: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
            ),
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: OverlayDateTimeContent(
            theme: widget.theme,
            textStyle: widget.textStyle,
            size: widget.size,
            controller: _dateTimePickerController,
            showWeekDays: true,
            onNextDate: nextDate,
            onPreviousDate: previousDate,
            dateTimeConstraint: widget.dateTimeConstraint,
            onNextPageButtonChild: widget.onNextPageButtonBuilder,
            onPreviousPageButtonChild: widget.onPreviousPageButtonBuilder,
          ),
        ),
      ),
    );
  }

  void nextDate() {
    if (!mounted) return;
    setState(() {
      _dateTimePickerController.browsingDate =
          _dateTimePickerController.browsingDate.add(
        Duration(
          days: DateTime(
            _dateTimePickerController.browsingDate.year,
            _dateTimePickerController.browsingDate.month,
          ).daysInMonth(),
        ),
      );
    });
  }

  void previousDate() {
    if (!mounted) return;
    setState(() {
      _dateTimePickerController.browsingDate =
          _dateTimePickerController.browsingDate.subtract(
        Duration(
          days: DateTime(
            _dateTimePickerController.browsingDate.year,
            _dateTimePickerController.browsingDate.month,
          ).daysInMonth(),
        ),
      );
    });
  }
}
