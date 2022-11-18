// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/src/models/date_time_picker_theme.dart';
import 'package:flutter_date_time_picker/src/utils/date_time_picker_controller.dart';
import 'package:flutter_date_time_picker/src/widgets/overlay_date_time_picker/date_picker.dart';
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
  });

  final DateTimePickerTheme theme;
  final TextStyle textStyle;
  final Size size;
  final DateTimePickerController controller;
  final bool showWeekDays;
  final void Function() onNextDate;
  final void Function() onPreviousDate;

  @override
  State<OverlayDateTimeContent> createState() => _OverlayDateTimeContentState();
}

class _OverlayDateTimeContentState extends State<OverlayDateTimeContent> {
  bool usesButtons = false;
  late final PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(initialPage: 1);
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
              onPressed: goToPreviousPage,
              icon: const Icon(Icons.arrow_circle_left_outlined),
              color: widget.theme.barTheme.barColor,
            ),
            Text(DateFormat.yMMMM().format(
              widget.controller.browsingDate,
            )),
            IconButton(
              onPressed: goToNextPage,
              icon: const Icon(Icons.arrow_circle_right_outlined),
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
            controller: _pageController,
            onPageChanged: (value) {
              if (!usesButtons) movePage(1 - value);
            },
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            allowImplicitScrolling: true,
            children: [
              DatePicker(
                controller: widget.controller,
                onSelectDate: onSelectDate,
                theme: widget.theme,
                textStyle: widget.textStyle,
                date: DateTime(
                  widget.controller.browsingDate.year,
                  widget.controller.browsingDate.month - 1,
                  1,
                ),
                showWeekDays: widget.showWeekDays,
              ),
              DatePicker(
                controller: widget.controller,
                onSelectDate: onSelectDate,
                theme: widget.theme,
                textStyle: widget.textStyle,
                date: widget.controller.browsingDate,
                showWeekDays: widget.showWeekDays,
              ),
              DatePicker(
                controller: widget.controller,
                onSelectDate: onSelectDate,
                theme: widget.theme,
                textStyle: widget.textStyle,
                date: DateTime(
                  widget.controller.browsingDate.year,
                  widget.controller.browsingDate.month + 1,
                  1,
                ),
                showWeekDays: widget.showWeekDays,
              ),
            ],
          ),
        )
      ],
    );
  }

  void goToNextPage() async {
    setState(() {
      usesButtons = true;
    });
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    nextPage();
  }

  void goToPreviousPage() async {
    setState(() {
      usesButtons = true;
    });
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    previousPage();
  }

  void nextPage() {
    widget.onNextDate.call();
    if (!mounted) return;
    setState(() {
      usesButtons = false;
    });
    _pageController.jumpToPage(1);
  }

  void previousPage() {
    widget.onPreviousDate.call();
    if (!mounted) return;
    setState(() {
      usesButtons = false;
    });
    _pageController.jumpToPage(1);
  }

  void movePage(int direction) {
    if (direction < 0) {
      nextPage();
    } else if (direction > 0) {
      previousPage();
    }
  }

  void onSelectDate(DateTime date) {
    if (!mounted) return;
    setState(() {
      widget.controller.selectedDate = date;
      movePage(widget.controller.browsingDate.month - date.month);
      widget.controller.onTapDayCallBack?.call(date);
    });
  }
}
