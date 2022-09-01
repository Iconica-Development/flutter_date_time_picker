import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/models/date_time_picker_theme.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/month_date_time_picker.dart/month_date_time_picker_sheet.dart';
import 'package:flutter_date_time_picker/src/widgets/week_date_time_picker/week_date_time_picker_sheet.dart';
import 'package:intl/date_symbol_data_local.dart';

/// A widget that displays a date picker from a sheet form the top of the screen.
/// This sheet displays initialy displays a week of days but can be dragged down to show full months.
/// Both views can be dragged sideways to show the next or previous week/month.
///
/// The child will be the [Widget] that is displayed underneath the date picker in the stack.
///
///
/// [initialDate] indicates the starting date. Default is [DateTime.now()
///
/// [pickTime] is a [bool] that determines if the user is able to pick a time after picking a date.
/// true will always tirgger a [TimePickerDialog].
/// false will nvever trigger a [TimePickerDialog]. This is default.
///
/// [use24HourFormat] is a [bool] to set de clock on [TimePickerDialog] to a fixed 24 or 12-hour format.
/// By default this gets determined by the [Locale] on the device.
///
/// [dateTimePickerTheme] is used the set the global theme of the [DateTimePicker]
///
/// The header [Widget] will be displayed above the date picker in the modal sheet in a column.
///
/// [onTapDay] is a callback that provides the taped date as a [DateTime] object.
///
/// [highlightToday] is a [bool] that determines which day shall we highlighted.
/// true will always highlight the current date. This is standard.
/// false will highlight the currently selected date by either the initial date or the one chosen by the user.
/// final Widget? child;
///
/// [markedDates] contain the dates [DateTime] that will be marked in the picker by a small dot.
///
/// [disabledDates] contain the dates [DateTime] that will be disabled and cannot be interacted with whatsoever.
///
/// [disabledTimes] contain the time [TimeOfDay] that cannot be picked in the [TimePickerDialog].
///
///
/// Example:
/// ```dart
/// DatePicker(
///   dateTimePickerTheme: const DateTimePickerTheme()
///   initialDate: selectedDate,
///   highlightToday: false,
///   onTapDay: (date) {
///     setState(() {
///       selectedDate = date;
///     });
///   },
///   markedDates: [
///     DateTime(2022, 7, 22),
///   ],
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
///               'Persoonlijk',
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
///               'Teamplanning',
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
///     child: ShellRoster(
///       startHour: 0,
///       endHour: 24,
///       blocks: [
///         for (Map<String, TimeOfDay> block in blocks) ...[
///           getBlock(block),
///         ],
///       ],
///     ),
///   ),
/// ),
///```
class DateTimePicker extends StatefulWidget {
  DateTimePicker({
    this.dateTimePickerTheme = const DateTimePickerTheme(),
    this.header,
    this.onTapDay,
    this.highlightToday = true,
    bool? use24HourFormat,
    this.pickTime = false,
    this.initialDate,
    this.markedDates,
    this.disabledDates,
    this.disabledTimes,
    this.child,
    super.key,
  }) {
    alwaysUse24HourFormat = use24HourFormat ?? useTimeFormatBasedOnLocale();
  }

  final Widget? child;
  final DateTimePickerTheme dateTimePickerTheme;
  final Widget? header;
  final Function(DateTime)? onTapDay;
  final bool highlightToday;
  late final bool alwaysUse24HourFormat;
  final bool pickTime;
  final DateTime? initialDate;
  final List<DateTime>? markedDates;
  final List<DateTime>? disabledDates;
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
            minChildSize: 0.2,
            initialChildSize: 0.2,
            maxChildSize: 0.6,
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
                            color: Colors.white,
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
                          child: dragSize < 0.3
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

bool useTimeFormatBasedOnLocale() {
  // Get LocaleName of current platform and split language- and countryCode in 2 List values.
  var deviceLocale = Platform.localeName.split('_');

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
