import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rooster')),
      body: DateTimePicker(
        // header: Container(
        //   height: 100,
        //   width: MediaQuery.of(context).size.width,
        //   padding: const EdgeInsets.only(bottom: 10),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const SizedBox(
        //         width: 160,
        //         height: 34,
        //         child: Center(
        //           child: Text(
        //             'Persoonlijk',
        //             style: TextStyle(
        //               fontSize: 16,
        //               fontWeight: FontWeight.w900,
        //             ),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(
        //         width: 4,
        //       ),
        //       Container(
        //         width: 160,
        //         height: 34,
        //         decoration: BoxDecoration(
        //           color: const Color(0xFF00273D),
        //           borderRadius: const BorderRadius.all(
        //             Radius.circular(10),
        //           ),
        //           boxShadow: [
        //             BoxShadow(
        //               color: const Color(0xFF000000).withOpacity(0.50),
        //               offset: const Offset(0, 6),
        //               blurRadius: 9,
        //             ),
        //           ],
        //         ),
        //         child: const Center(
        //           child: Text(
        //             'Teamplanning',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 16,
        //               fontWeight: FontWeight.w900,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        disabledDates: [DateTime(2022, 8, 26), DateTime(2022, 8, 27)],
        markedDates: [DateTime(2022, 8, 28), DateTime(2022, 8, 29)],
        disabledTimes: const [TimeOfDay(hour: 12, minute: 0)],
        pickTime: true,
        child: Container(),
      ),
    );
  }
}
