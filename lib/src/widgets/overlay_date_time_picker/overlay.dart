// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/models/date_time_picker_theme.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/utils/locking_page_scroll_physics.dart';
import 'package:flutter_date_time_picker/src/widgets/overlay_date_time_picker/date_picker.dart';
import 'package:flutter_date_time_picker/src/models/date_constraint.dart';
import 'package:intl/intl.dart';

class OverlayDateTimeContent extends StatefulWidget {
  const OverlayDateTimeContent({
    super.key,
    required this.theme,
    required this.textStyle,
    required this.size,
    required this.controller,
    required this.showWeekDays,
    required this.onNextDate,
    required this.onPreviousDate,
    required this.dateTimeConstraint,
    required this.onPreviousPageButtonChild,
    required this.onNextPageButtonChild,
  });

  final DateTimePickerTheme theme;
  final TextStyle textStyle;
  final Size size;
  final DateTimePickerController controller;
  final bool showWeekDays;
  final DateTimeConstraint dateTimeConstraint;

  final Widget? onNextPageButtonChild;
  final Widget? onPreviousPageButtonChild;

  final void Function() onNextDate;
  final void Function() onPreviousDate;

  @override
  State<OverlayDateTimeContent> createState() => _OverlayDateTimeContentState();
}

class _OverlayDateTimeContentState extends State<OverlayDateTimeContent> {
  bool usesButtons = false;
  late DateTime nextDate;
  late DateTime previousDate;
  late final PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(initialPage: 1);
    nextDate = DateTime(
      widget.controller.browsingDate.year,
      widget.controller.browsingDate.month + 1,
      1,
    );
    previousDate = DateTime(
      widget.controller.browsingDate.year,
      widget.controller.browsingDate.month - 1,
      1,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: (widget.dateTimeConstraint.inMonthRange(previousDate))
                  ? _goToPreviousPage
                  : null,
              icon: widget.onPreviousPageButtonChild ??
                  const Icon(Icons.arrow_circle_left_outlined),
              color: widget.theme.barTheme.barColor,
            ),
            Text(
              DateFormat.yMMMM().format(
                widget.controller.browsingDate,
              ),
              style: widget.theme.baseTheme.textStyle,
            ),
            IconButton(
              onPressed: (widget.dateTimeConstraint.inMonthRange(nextDate))
                  ? _goToNextPage
                  : null,
              icon: widget.onNextPageButtonChild ??
                  const Icon(Icons.arrow_circle_right_outlined),
              color: widget.theme.barTheme.barColor,
            ),
          ],
        ),
        Container(
          height: 2,
          decoration: BoxDecoration(
            color: widget.theme.barTheme.barColor,
          ),
        ),
        Expanded(
          child: PageView(
            physics: LockingPageScrollPhysics(
              allowedNextPage: () =>
                  widget.dateTimeConstraint.inMonthRange(nextDate),
              allowedPreviousPage: () =>
                  widget.dateTimeConstraint.inMonthRange(previousDate),
            ),
            controller: _pageController,
            onPageChanged: (value) {
              if (!usesButtons) _movePage(1 - value);
            },
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            allowImplicitScrolling: true,
            children: [
              DatePicker(
                controller: widget.controller,
                onSelectDate: _onSelectDate,
                theme: widget.theme,
                textStyle: widget.textStyle,
                date: previousDate,
                dateTimeConstraint: widget.dateTimeConstraint,
                showWeekDays: widget.showWeekDays,
              ),
              DatePicker(
                controller: widget.controller,
                onSelectDate: _onSelectDate,
                theme: widget.theme,
                textStyle: widget.textStyle,
                date: widget.controller.browsingDate,
                showWeekDays: widget.showWeekDays,
                dateTimeConstraint: widget.dateTimeConstraint,
              ),
              DatePicker(
                controller: widget.controller,
                onSelectDate: _onSelectDate,
                theme: widget.theme,
                textStyle: widget.textStyle,
                date: nextDate,
                dateTimeConstraint: widget.dateTimeConstraint,
                showWeekDays: widget.showWeekDays,
              ),
            ],
          ),
        )
      ],
    );
  }

  void _goToNextPage() async {
    setState(() {
      usesButtons = true;
    });
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    _nextPage();
  }

  void _goToPreviousPage() async {
    setState(() {
      usesButtons = true;
    });
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    _previousPage();
  }

  void _nextPage() {
    widget.onNextDate.call();
    if (!mounted) return;
    _pageController.jumpToPage(1);
    setState(() {
      usesButtons = false;
    });
    _setDates();
  }

  void _previousPage() {
    widget.onPreviousDate.call();
    if (!mounted) return;
    _pageController.jumpToPage(1);
    setState(() {
      usesButtons = false;
    });
    _setDates();
  }

  void _movePage(int direction) {
    if (direction < 0) {
      _nextPage();
    } else if (direction > 0) {
      _previousPage();
    }
  }

  void _onSelectDate(DateTime date) {
    if (!mounted) return;
    setState(() {
      widget.controller.selectedDate = date;
      _movePage(widget.controller.browsingDate.month - date.month);
      widget.controller.onTapDayCallBack?.call(date);
    });
  }

  void _setDates() {
    if (!mounted) return;
    setState(() {
      nextDate = DateTime(
        widget.controller.browsingDate.year,
        widget.controller.browsingDate.month + 1,
        1,
      );
      previousDate = DateTime(
        widget.controller.browsingDate.year,
        widget.controller.browsingDate.month - 1,
        1,
      );
    });
  }
}
