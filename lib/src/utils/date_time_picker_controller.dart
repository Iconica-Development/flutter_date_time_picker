// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

/// Controller for managing date and time selection.
class DateTimePickerController extends ChangeNotifier {
  /// Callback that provides the date tapped on as a [DateTime] object.
  final Function(DateTime)? onTapDayCallBack;

  /// Callback triggered when the date scrolls to the border.
  final Function(DateTime)? onBorderScrollCallback;

  /// Initial date.
  final DateTime initialDate;

  /// Page controller for managing the date selection.
  final PageController _pageController = PageController(initialPage: 1);

  /// The currently browsed date.
  late DateTime browsingDate = initialDate;

  /// The selected date.
  late DateTime selectedDate = initialDate;

  /// Constructs a DateTimePickerController.
  DateTimePickerController({
    required this.initialDate,
    this.onTapDayCallBack,
    this.onBorderScrollCallback,
  });

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Callback for page change.
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

  /// Callback for tapping a day.
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

  /// Callback for scrolling to the border.
  void onBorderScroll(DateTime date) {
    browsingDate = date;
    selectedDate = date;
    notifyListeners();
    onBorderScrollCallback?.call(date);
  }

  /// Retrieves the page controller.
  PageController get pageController => _pageController;

  /// Sets the browsing date.
  void setBrowsingDate(DateTime date) {
    browsingDate = date;
    notifyListeners();
  }

  /// Sets the selected date.
  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
