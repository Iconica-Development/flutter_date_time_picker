// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
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

  _DropdownRoute? _dropdownRoute;

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
        Navigator.of(context).pop();
      }
    },
    browsingDate: widget.initialDate ?? DateTime.now(),
    selectedDate: widget.initialDate ?? DateTime.now(),
  );

  @override
  void dispose() {
    _dateTimePickerController.dispose();
    super.dispose();
  }

  void _onPressed() async {
    if (!mounted) return;
    setState(() {
      _isShown = !_isShown;
    });
    final TextDirection? textDirection = Directionality.maybeOf(context);

    final NavigatorState navigator = Navigator.of(context);

    final RenderBox buttonBox = context.findRenderObject()! as RenderBox;
    final Rect buttonRect = buttonBox.localToGlobal(Offset.zero,
            ancestor: navigator.context.findRenderObject()) &
        buttonBox.size;

    _dropdownRoute = _DropdownRoute(
      child: _buildOverlay(context),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      buttonRect:
          EdgeInsets.zero.resolve(textDirection).inflateRect(buttonRect),
      alignment: widget.alignment,
      menuSize: widget.size,
    );
    await navigator.push(_dropdownRoute!);
    if (!mounted) {
      return;
    }

    _close();
  }

  void _close() {
    if (!mounted) return;
    setState(() {
      _isShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buttonBuilder != null) {
      return widget.buttonBuilder!.call(
        buttonKey,
        () {
          _onPressed();
        },
      );
    }
    return ElevatedButton(
        key: buttonKey,
        onPressed: () {
          _onPressed();
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
      _dateTimePickerController.browsingDate = DateTime(
        _dateTimePickerController.browsingDate.year,
        _dateTimePickerController.browsingDate.month + 1,
        _dateTimePickerController.browsingDate.day,
      );
    });
  }

  void previousDate() {
    if (!mounted) return;
    setState(() {
      _dateTimePickerController.browsingDate = DateTime(
        _dateTimePickerController.browsingDate.year,
        _dateTimePickerController.browsingDate.month - 1,
        _dateTimePickerController.browsingDate.day,
      );
    });
  }
}

class _DropdownRoute extends PopupRoute<Widget> {
  _DropdownRoute({
    required this.barrierLabel,
    required this.child,
    required this.alignment,
    required this.menuSize,
    required this.buttonRect,
  });

  final Widget child;
  final Alignment alignment;
  final Size menuSize;
  final Rect buttonRect;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CustomSingleChildLayout(
      delegate: _DropdownMenuLayoutDelegate(
        buttonRect: buttonRect,
        menuSize: menuSize,
        alignment: alignment,
      ),
      child: Material(child: child),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  void dismiss() {
    navigator?.pop();
  }
}

class _DropdownMenuLayoutDelegate extends SingleChildLayoutDelegate {
  _DropdownMenuLayoutDelegate({
    required this.buttonRect,
    required this.menuSize,
    required this.alignment,
  });

  final Rect buttonRect;
  final Size menuSize;
  final Alignment alignment;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: menuSize.width,
      maxWidth: menuSize.width,
      minHeight: menuSize.height,
      maxHeight: menuSize.height,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    Rect pop = Offset.zero & childSize;
    pop.center;
    return buttonRect.center -
        pop.center +
        Offset(
          (childSize.width + buttonRect.width) * 0.5 * alignment.x,
          (childSize.height + buttonRect.height) * 0.5 * alignment.y,
        );
  }

  @override
  bool shouldRelayout(_DropdownMenuLayoutDelegate oldDelegate) {
    return buttonRect != oldDelegate.buttonRect;
  }
}
