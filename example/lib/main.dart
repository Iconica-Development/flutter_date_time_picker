// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo drag down date time picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Demo'),
        ),
        body: const DatePickerDemo(),
      ),
    );
  }
}

class DatePickerDemo extends StatelessWidget {
  const DatePickerDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const dateTimePickerTheme = DateTimePickerTheme(
      dateBoxShape: DateBoxShape.roundedRectangle,
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
    );

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OverlayDateTimePicker(
                theme: dateTimePickerTheme,
                alignment: Alignment.bottomCenter,
                child: const Text("Select Day"),
                onTapDay: (date) {},
              ),
              OverlayDateTimePicker(
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
                onNextPageButtonChild: const Icon(Icons.add),
                onPreviousPageButtonChild: const Icon(Icons.minimize),
              )
            ],
          ),
        ),
        DragDownDateTimePicker(
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
          markedDates: [DateTime(2022, 9, 6)],
        )
      ],
    );
  }
}
