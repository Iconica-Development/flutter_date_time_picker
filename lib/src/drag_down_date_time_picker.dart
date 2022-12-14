// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/models/date_time_picker_theme.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/month_date_time_picker/month_date_time_picker_sheet.dart';
import 'package:flutter_date_time_picker/src/widgets/week_date_time_picker/week_date_time_picker_sheet.dart';
import 'package:intl/date_symbol_data_local.dart';

class DragDownDateTimePicker extends StatefulWidget {
  /// A widget that displays a date picker from a sheet form the top of the screen.
  /// This sheet displays initially displays a week but can be dragged down to show a full month.
  /// Both views can be dragged sideways to show the next or previous week/month.

  const DragDownDateTimePicker({
    this.dateTimePickerTheme = const DateTimePickerTheme(),
    this.header,
    this.onTimerPickerSheetChange,
    this.onTapDay,
    this.highlightToday = true,
    this.wrongTimeDialog,
    this.alwaysUse24HourFormat,
    this.pickTime = false,
    this.initialDate,
    this.markedDates,
    this.disabledDates,
    this.disabledTimes,
    this.child,
    super.key,
  });

  /// The child contained by the DatePicker.
  final Widget? child;

  /// A [Widget] to display when the user picks a disabled time in the [TimePickerDialog]
  final Widget? wrongTimeDialog;

  /// Visual properties for the [DragDownDateTimePicker]
  final DateTimePickerTheme dateTimePickerTheme;

  /// Widget shown at the top of the [DragDownDateTimePicker]
  final Widget? header;

  /// Callback that provides the date tapped on as a [DateTime] object.
  final Function(DateTime)? onTapDay;

  /// Whether the current day should be highlighted in the [DragDownDateTimePicker]
  final bool highlightToday;

  /// a [bool] to set de clock on [TimePickerDialog] to a fixed 24 or 12-hour format.
  /// By default this gets determined by the settings on the user device.
  final bool? alwaysUse24HourFormat;

  /// [pickTime] is a [bool] that determines if the user is able to pick a time after picking a date using the [TimePickerDialog].
  final bool pickTime;

  /// indicates the starting date. Default is [DateTime.now()]
  final DateTime? initialDate;

  /// [markedDates] contain the dates [DateTime] that will be marked in the [DragDownDateTimePicker] by a small dot.
  final List<DateTime>? markedDates;

  /// a [List] of [DateTime] objects that will be disabled and cannot be interacted with whatsoever.
  final List<DateTime>? disabledDates;

  /// a [List] of [TimeOfDay] objects that cannot be picked in the [TimePickerDialog].
  final List<TimeOfDay>? disabledTimes;

  /// Function that gets called when the view changes from week to month or vice versa.
  /// The value is the amount of scrolledpixels.
  final Function(double)? onTimerPickerSheetChange;

  @override
  State<StatefulWidget> createState() => _DragDownDateTimePickerState();
}

class _DragDownDateTimePickerState extends State<DragDownDateTimePicker> {
  late DateTimePickerController _dateTimePickerController;

  final DraggableScrollableController _dragController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    _dateTimePickerController = DateTimePickerController(
      highlightToday: widget.highlightToday,
      alwaysUse24HourFormat: widget.alwaysUse24HourFormat,
      pickTime: widget.pickTime,
      theme: widget.dateTimePickerTheme,
      header: widget.header,
      markedDates: widget.markedDates,
      disabledDates: widget.disabledDates,
      disabledTimes: widget.disabledTimes,
      onTapDayCallBack: widget.onTapDay,
      browsingDate: widget.initialDate ?? DateTime.now(),
      selectedDate: widget.initialDate ?? DateTime.now(),
    );

    _dateTimePickerController.addListener(() {
      setState(() {});
    });
    _dragController.addListener(() {
      widget.onTimerPickerSheetChange?.call(_dragController.pixels);
    });
  }

  @override
  void dispose() {
    _dateTimePickerController.dispose();
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) ...[
          widget.child!,
        ],
        RotatedBox(
          quarterTurns: 2,
          child: DraggableScrollableSheet(
            controller: _dragController,
            snap: true,
            minChildSize: _dateTimePickerController.theme.weekViewSize,
            initialChildSize: _dateTimePickerController.theme.weekViewSize,
            maxChildSize: _dateTimePickerController.theme.monthViewSize,
            builder: (context, scrollController) {
              double dragSize =
                  _dragController.isAttached ? _dragController.size : 0;
              return RotatedBox(
                quarterTurns: 2,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      reverse: true,
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                _dateTimePickerController.theme.backgroundColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: dragSize <
                                  _dateTimePickerController
                                      .theme.weekMonthTriggerSize
                              ? WeekDateTimePickerSheet(
                                  dateTimePickerController:
                                      _dateTimePickerController,
                                  weekDateBoxSize: widget
                                      .dateTimePickerTheme.weekDateBoxSize,
                                )
                              : MonthDateTimePickerSheet(
                                  dateTimePickerController:
                                      _dateTimePickerController,
                                  monthDateBoxSize: widget
                                      .dateTimePickerTheme.monthDateBoxSize,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
