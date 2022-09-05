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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Roster'),
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
    return DateTimePicker(
      dateTimePickerTheme: const DateTimePickerTheme(
          markedIndicatorColor: Colors.red,
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
          )),
      markedDates: [DateTime(2022, 9, 6)],
    );
  }
}
