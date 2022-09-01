import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/enums/date_box_shape.dart';

class DateTimePickerController extends ChangeNotifier {
  DateTimePickerController({
    required this.highlightToday,
    required this.alwaysUse24HourFormat,
    required this.pickTime,
    required this.dateBoxShape,
    
    this.header,
    this.markedDates,
    this.disabledDates,
    this.disabledTimes,
    this.onTapDayCallBack,
    required this.browsingDate,
    required this.selectedDate,
  });

  
  final PageController _pageController = PageController(initialPage: 1);

  final bool highlightToday;
  final bool? alwaysUse24HourFormat;

  final Widget? header;

  final DateBoxShape dateBoxShape;

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
