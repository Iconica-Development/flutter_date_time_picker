// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class DateTimePickerController extends ChangeNotifier {
  DateTimePickerController({
    required this.initialDate,
    this.onTapDayCallBack,
    this.onBorderScrollCallback,
  });

  /// Callback that provides the date tapped on as a [DateTime] object.
  final Function(DateTime)? onTapDayCallBack;

  /// Callback that provides the new date which is scroll to. If this is null the scroll feature is disabled.
  final Function(DateTime)? onBorderScrollCallback;

  final DateTime initialDate;

  final PageController _pageController = PageController(initialPage: 1);

  late DateTime browsingDate = initialDate;
  late DateTime selectedDate = initialDate;

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

  void onBorderScroll(DateTime date) {
    browsingDate = date;
    selectedDate = date;

    notifyListeners();

    onBorderScrollCallback?.call(
      date,
    );
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
