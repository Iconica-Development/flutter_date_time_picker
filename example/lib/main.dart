// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:datetime_picker_example/shaped_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // set locale to dutch
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('nl', 'NL'),
      supportedLocales: const [
        Locale('nl', 'NL'),
        Locale('en', 'US'),
      ],
      title: 'Demo drag down date time picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DatePickerDemo(),
    );
  }
}

class DatePickerDemo extends StatelessWidget {
  const DatePickerDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // set locale to Dutch
    DateTimePickerTheme dateTimePickerTheme = DateTimePickerTheme(
      dateFormatWeekday: (value) =>
          value[0].toUpperCase() + value.substring(1).toLowerCase(),
      dateFormatMonth: (value) => value.toUpperCase(),
      prevIcon: (context) => const Icon(Icons.chevron_left_sharp),
      nextIcon: (context) => const Icon(Icons.chevron_right_sharp),
      dateBoxShape: DateBoxShape.circle,
      backgroundColor: Colors.white,
      markedIndicatorColor: Colors.red,
      baseTheme: const DateBoxBaseTheme(
        Colors.white,
        TextStyle(color: Colors.black),
      ),
      selectedTheme: const DateBoxSelectedTheme(
        Color(0x4BF44336),
        TextStyle(
          color: Colors.black,
        ),
      ),
      highlightTheme: const DateBoxHighlightTheme(
        Colors.red,
        TextStyle(
          color: Colors.white,
        ),
      ),
      barTheme: const DateTimePickerBarTheme(
          barColor: Colors.pinkAccent,
          barOpacity: 1,
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      paginationSize: 25,
      shapeBorder: const ArrowedBorder(),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Demo'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: DateTimePicker(
              theme: dateTimePickerTheme,
              size: const Size(270, 340),
              onTapDay: (date) {},
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OverlayDateTimePicker(
                  markedDates: [DateTime.now().add(const Duration(days: 1))],
                  theme: dateTimePickerTheme,
                  alignment: Alignment.bottomCenter,
                  child: const Text("Select Day"),
                  onTapDay: (date) {},
                ),
                OverlayDateTimePicker(
                  markedDates: [DateTime.now().add(const Duration(days: 3))],
                  theme: dateTimePickerTheme,
                  alignment: Alignment.center,
                  buttonBuilder: (key, onPressed) => TextButton(
                    key: key,
                    onPressed: onPressed,
                    child: const Text("Select Day"),
                  ),
                  dateTimeConstraint: DateTimeConstraint(
                    min: DateConstraint(date: DateTime.now()),
                  ),
                ),
                OverlayDateTimePicker(
                  theme: dateTimePickerTheme,
                  alignment: Alignment.topCenter,
                  buttonBuilder: (key, onPressed) => IconButton(
                    key: key,
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.schedule,
                    ),
                  ),
                  dateTimeConstraint: DateTimeConstraint(
                    min: DateConstraint(date: DateTime.now()),
                    max: DateConstraint(
                      date: DateTime(
                        DateTime.now().year,
                        DateTime.now().month + 4,
                        DateTime.now().day,
                      ),
                    ),
                  ),
                  onNextPageButtonBuilder: (onPressed) {
                    return IconButton(
                        onPressed: onPressed, icon: const Icon(Icons.add));
                  },
                  onPreviousPageButtonBuilder: (onPressed) {
                    return IconButton(
                        onPressed: onPressed, icon: const Icon(Icons.minimize));
                  },
                ),
              ],
            ),
          ),
          DragDownDateTimePicker(
            onTimerPickerSheetChange: (value) {},
            alwaysUse24HourFormat: true,
            dateTimePickerTheme: const DateTimePickerTheme(
              backgroundColor: Colors.white,
              markedIndicatorColor: Colors.red,
              baseTheme: DateBoxBaseTheme(
                Colors.white,
                TextStyle(color: Colors.black),
              ),
              selectedTheme: DateBoxSelectedTheme(
                Color(0x4BF44336),
                TextStyle(
                  color: Colors.red,
                ),
              ),
              highlightTheme: DateBoxHighlightTheme(
                Colors.red,
                TextStyle(
                  color: Colors.white,
                ),
              ),
              barTheme: DateTimePickerBarTheme(
                barColor: Colors.black,
                barOpacity: 1,
              ),
            ),
            markedDates: [DateTime.now().subtract(const Duration(days: 1))],
          ),
        ],
      ),
    );
  }
}
