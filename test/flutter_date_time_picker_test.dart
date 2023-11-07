// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Render App with DateTimePicker Widget', (tester) async {
    // Render App
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: DragDownDateTimePicker(
          controller: DateTimePickerController(
            initialDate: DateTime.now(),
          ),
          configuration: DateTimePickerConfiguration(
            theme: const DateTimePickerTheme(),
            highlightToday: true,
            pickTime: false,
          ),
          child: Container(),
        ),
      ),
    ));
    await tester.pump();
  });

  testWidgets('Test if DateTimePicker Widget swipes', (tester) async {
    // Render App
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: DragDownDateTimePicker(
          controller: DateTimePickerController(
            initialDate: DateTime.now(),
          ),
          configuration: DateTimePickerConfiguration(
            theme: const DateTimePickerTheme(),
            highlightToday: true,
            pickTime: false,
          ),
          child: Container(),
        ),
      ),
    ));
    await tester.pump();

    // Forward
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(500.0, 0.0));
    await tester.pumpAndSettle();

    // Return
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    // Backward
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();
  });
}
