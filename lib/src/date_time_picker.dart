// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/models/date_time_picker_theme.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/month_date_time_picker/month_date_time_picker_sheet.dart';
import 'package:flutter_date_time_picker/src/widgets/week_date_time_picker/week_date_time_picker_sheet.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateTimePicker extends StatefulWidget {
  /// A widget that displays a date picker from a sheet form the top of the screen.
  /// This sheet displays initially displays a week but can be dragged down to show a full month.
  /// Both views can be dragged sideways to show the next or previous week/month.
  ///
  /// Example:
  /// ```dart
  /// DatePicker(
  ///   dateTimePickerTheme: const DateTimePickerTheme()
  ///   initialDate: selectedDate,
  ///   highlightToday: true,
  ///   onTapDay: (date) {
  ///     setState(() {
  ///       selectedDate = date;
  ///     });
  ///   },
  ///   markedDates: [
  ///     DateTime(2022, 3, 14),
  ///   ],
  ///   wrongTimeDialog:
  ///   AlertDialog(
  ///     title: const Text('Invalid Time'),
  ///     content: SingleChildScrollView(
  ///     child: ListBody(
  ///     children: const <Widget>[
  ///     Text(
  ///       'The time you try to choose is diabled, try to pick another time.'),
  ///     ],
  ///    ),
  ///   ),
  ///     actions: <Widget>[
  ///       TextButton(
  ///         child: const Text('OK'),
  ///          onPressed: () {
  ///           Navigator.pop(context);
  ///          },
  ///         ),
  ///       ],
  ///      ),
  ///   header: Container(
  ///     height: 100,
  ///     width: MediaQuery.of(context).size.width,
  ///     padding: const EdgeInsets.only(bottom: 10),
  ///     child: Row(
  ///       crossAxisAlignment: CrossAxisAlignment.end,
  ///       mainAxisAlignment: MainAxisAlignment.center,
  ///       children: [
  ///         const SizedBox(
  ///           width: 160,
  ///           height: 34,
  ///           child: Center(
  ///             child: Text(
  ///               'Personal calendar',
  ///               style: TextStyle(
  ///                 fontSize: 16,
  ///                 fontWeight: FontWeight.w900,
  ///               ),
  ///             ),
  ///           ),
  ///         ),
  ///         const SizedBox(
  ///           width: 4,
  ///         ),
  ///         Container(
  ///           width: 160,
  ///           height: 34,
  ///           decoration: BoxDecoration(
  ///             color: const Color(0xFF00273D),
  ///             borderRadius: const BorderRadius.all(
  ///               Radius.circular(10),
  ///             ),
  ///             boxShadow: [
  ///               BoxShadow(
  ///                 color: const Color(0xFF000000).withOpacity(0.50),
  ///                 offset: const Offset(0, 6),
  ///                 blurRadius: 9,
  ///               ),
  ///             ],
  ///           ),
  ///           child: const Center(
  ///             child: Text(
  ///               'Work calendar',
  ///               style: TextStyle(
  ///                 color: Colors.white,
  ///                 fontSize: 16,
  ///                 fontWeight: FontWeight.w900,
  ///               ),
  ///             ),
  ///           ),
  ///         ),
  ///       ],
  ///     ),
  ///   ),
  ///   child: Container(
  ///     margin: const EdgeInsets.only(
  ///       top: 195,
  ///     ),
  ///     child: HolidayRoster(),
  ///   ),
  /// ),
  ///```
  DateTimePicker({
    this.dateTimePickerTheme = const DateTimePickerTheme(),
    this.header,
    this.onTapDay,
    this.highlightToday = true,
    this.wrongTimeDialog,
    bool? use24HourFormat,
    this.pickTime = false,
    this.initialDate,
    this.markedDates,
    this.disabledDates,
    this.disabledTimes,
    this.child,
    super.key,
  }) {
    alwaysUse24HourFormat = use24HourFormat ?? _useTimeFormatBasedOnLocale();
  }

  /// The child contained by the DatePicker.
  final Widget? child;

  /// A [Widget] to display when the user picks a disabled time in the [TimePickerDialog]
  final Widget? wrongTimeDialog;

  /// Visual properties for the [DateTimePicker]
  final DateTimePickerTheme dateTimePickerTheme;

  /// Widget shown at the top of the [DateTimePicker]
  final Widget? header;

  /// Callback that provides the date tapped on as a [DateTime] object.
  final Function(DateTime)? onTapDay;

  /// Whether the current day should be highlighted in the [DateTimePicker]
  final bool highlightToday;

  /// a [bool] to set de clock on [TimePickerDialog] to a fixed 24 or 12-hour format.
  /// By default this gets determined by the [Locale] on the device.
  late final bool alwaysUse24HourFormat;

  /// [pickTime] is a [bool] that determines if the user is able to pick a time after picking a date usring the [TimePickerDialog].
  final bool pickTime;

  /// indicates the starting date. Default is [DateTime.now()]
  final DateTime? initialDate;

  /// [markedDates] contain the dates [DateTime] that will be marked in the [DateTimePicker] by a small dot.
  final List<DateTime>? markedDates;

  /// a [List] of [DateTime] objects that will be disabled and cannot be interacted with whatsoever.
  final List<DateTime>? disabledDates;

  /// a [List] of [TimeOfDay] objects that cannot be picked in the [TimePickerDialog].
  final List<TimeOfDay>? disabledTimes;

  @override
  State<StatefulWidget> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
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
                          child: dragSize < _dateTimePickerController.theme.weekMonthTriggerSize
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

bool _useTimeFormatBasedOnLocale() {
  // Get LocaleName of current platform and split language- and countryCode in 2 List values.
  List<String> deviceLocale = Platform.localeName.split('_');

  // Make LocaleName of current platform in a Locale Object
  Locale defaultLocale = Locale.fromSubtags(
    languageCode: deviceLocale[0],
    countryCode: deviceLocale[1],
  );

  // Determine Country.
  switch (defaultLocale.countryCode) {
    case 'NL':
      return true;
    case 'US':
      return false;
    default:
      return true;
  }
}
