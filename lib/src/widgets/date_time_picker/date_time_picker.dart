import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/overlay_date_time_picker/overlay.dart';

class DateTimePicker extends StatefulWidget {
  /// The child contained by the DatePicker.
  final Widget? child;

  /// Visual properties for the [OverlayDateTimePicker]
  final DateTimePickerTheme theme;

  /// Style to base the text on
  final TextStyle weekdayTextStyle;

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

  //final DateTime MonthChangeCallback = void Function(DateTime newMonth);
  final void Function(DateTime newMonth)? onMonthChanged;

  const DateTimePicker({
    super.key,
    this.child,
    required this.theme,
    this.weekdayTextStyle = const TextStyle(),
    this.onTapDay,
    this.highlightToday = true,
    this.alwaysUse24HourFormat = true,
    this.pickTime = false,
    this.initialDate,
    this.markedDates,
    this.disabledDates,
    this.disabledTimes,
    required this.size,
    this.buttonBuilder,
    this.closeOnSelectDate = false,
    this.showWeekDays = true,
    this.dateTimeConstraint = const DateTimeConstraint(),
    this.onNextPageButtonBuilder,
    this.onPreviousPageButtonBuilder,
    this.onMonthChanged,
  });
  //final MonthChangeCallback? onMonthChanged;
  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: (widget.theme.shapeDecoration == null)
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
              shape: widget.theme.shapeDecoration!.shape,
              color: widget.theme.backgroundColor,
              image: (widget.theme.shapeDecoration!.image) ??
                  widget.theme.shapeDecoration!.image,
              gradient: (widget.theme.shapeDecoration!.gradient) ??
                  widget.theme.shapeDecoration!.gradient,
              shadows: (widget.theme.shapeDecoration!.shadows == null)
                  ? [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ]
                  : widget.theme.shapeDecoration!.shadows,
            ),
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Padding(
          padding: widget.theme.calenderPadding,
          child: OverlayDateTimeContent(
            theme: widget.theme,
            weekdayTextStyle: widget.weekdayTextStyle,
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
      widget.onMonthChanged?.call(_dateTimePickerController.browsingDate);
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
      widget.onMonthChanged?.call(_dateTimePickerController.browsingDate);
    });
  }
}
