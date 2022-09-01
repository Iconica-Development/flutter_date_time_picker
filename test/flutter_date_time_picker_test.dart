import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';

void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Scaffold(
      appBar: AppBar(),
      body: DateTimePicker(
        pickTime: false,
        child: Container(),
      ),
    ));
  });
}
