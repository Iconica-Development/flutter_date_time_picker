// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/models/date_time_picker_theme.dart';

class DateTimePickerController extends ChangeNotifier {
  DateTimePickerController({
    required this.theme,
    required this.highlightToday,
    required this.pickTime,
    required this.browsingDate,
    required this.selectedDate,
    this.alwaysUse24HourFormat,
    this.header,
    this.wrongTimeDialog,
    this.markedDates,
    this.disabledDates,
    this.disabledTimes,
    this.onTapDayCallBack,
  });

  final PageController _pageController = PageController(initialPage: 1);

  final bool highlightToday;
  final bool? alwaysUse24HourFormat;

  final Widget? header;

  final Widget? wrongTimeDialog;

  final DateTimePickerTheme theme;

  final List<DateTime>? markedDates;
  final List<DateTime>? disabledDates;
  final List<TimeOfDay>? disabledTimes;
  final bool pickTime;

  final Function(DateTime)? onTapDayCallBack;

  DateTime browsingDate;
  DateTime selectedDate;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(DateTime date) {
    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        browsingDate = date;

        notifyListeners();

        _pageController.jumpToPage(1);
      },
    );
  }

  void onTapDay(DateTime date) {
    browsingDate = date;
    selectedDate = date;

    notifyListeners();

    if (onTapDayCallBack != null) {
      onTapDayCallBack!.call(
        date,
      );
    }
  }

  PageController get pageController => _pageController;

  void setBrowsingDate(DateTime date) {
    browsingDate = date;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
