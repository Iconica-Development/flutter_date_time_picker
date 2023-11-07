// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_config.dart';

import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/month_date_time_picker/month_date_time_picker_sheet.dart';
import 'package:flutter_date_time_picker/src/widgets/week_date_time_picker/week_date_time_picker_sheet.dart';
import 'package:intl/date_symbol_data_local.dart';

class DragDownDateTimePicker extends StatefulWidget {
  /// A widget that displays a date picker from a sheet form the top of the screen.
  /// This sheet displays initially displays a week but can be dragged down to show a full month.
  /// Both views can be dragged sideways to show the next or previous week/month.

  const DragDownDateTimePicker({
    required this.controller,
    required this.configuration,
    this.onTimerPickerSheetChange,
    this.wrongTimeDialog,
    this.child,
    super.key,
  });

  final DateTimePickerController controller;
  final DateTimePickerConfiguration configuration;

  /// The child contained by the DatePicker.
  final Widget? child;

  /// A [Widget] to display when the user picks a disabled time in the [TimePickerDialog]
  final Widget? wrongTimeDialog;

  /// Function that gets called when the view changes from week to month or vice versa.
  /// The value is the amount of scrolledpixels.
  final Function(double)? onTimerPickerSheetChange;

  @override
  State<StatefulWidget> createState() => _DragDownDateTimePickerState();
}

class _DragDownDateTimePickerState extends State<DragDownDateTimePicker> {
  late final DateTimePickerController _dateTimePickerController =
      widget.controller;

  final DraggableScrollableController _dragController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    _dateTimePickerController.addListener(() {
      setState(() {});
    });
    _dragController.addListener(() {
      widget.onTimerPickerSheetChange?.call(_dragController.pixels);
      setState(() {});
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
            minChildSize: widget.configuration.theme.weekViewSize,
            initialChildSize: widget.configuration.theme.weekViewSize,
            maxChildSize: widget.configuration.theme.monthViewSize,
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
                            color: widget.configuration.theme.backgroundColor,
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
                                  widget
                                      .configuration.theme.weekMonthTriggerSize
                              ? WeekDateTimePickerSheet(
                                  dateTimePickerController:
                                      _dateTimePickerController,
                                  dateTimePickerConfiguration:
                                      widget.configuration,
                                  weekDateBoxSize: widget
                                      .configuration.theme.weekDateBoxSize,
                                )
                              : MonthDateTimePickerSheet(
                                  dateTimePickerController:
                                      _dateTimePickerController,
                                  dateTimePickerConfiguration:
                                      widget.configuration,
                                  monthDateBoxSize: widget
                                      .configuration.theme.monthDateBoxSize,
                                  monthDatePadding: widget
                                      .configuration.theme.monthDatePadding,
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
