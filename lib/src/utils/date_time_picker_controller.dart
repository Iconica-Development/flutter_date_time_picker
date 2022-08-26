import 'package:flutter/material.dart';

class DateTimePickerController extends ChangeNotifier {
  DateTimePickerController({
    required this.highlightToday,
    this.header,
    this.markedDates,
    this.onTapDayCallBack,
    required this.browsingDate,
    required this.selectedDate,
  });

  final DraggableScrollableController _dragController =
      DraggableScrollableController();
  final PageController _pageController = PageController(initialPage: 1);

  final bool highlightToday;

  final Widget? header;

  final List<DateTime>? markedDates;

  final Function(DateTime)? onTapDayCallBack;

  DateTime browsingDate;
  DateTime selectedDate;

  @override
  void dispose() {
    _pageController.dispose();
    _dragController.dispose();
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

  void onTapDay(date) {
    browsingDate = date;
    selectedDate = date;

    notifyListeners();

    if (onTapDayCallBack != null) {
      onTapDayCallBack!.call(
        date,
      );
    }
  }

  DraggableScrollableController getDragController() {
    return _dragController;
  }

  PageController getPageController() {
    return _pageController;
  }

  void setBrowsingDate(DateTime date) {
    browsingDate = date;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
