import 'package:flutter/material.dart';
import 'package:transport_booking_system_conductor_mobile/views/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(fontFamily: 'BalsamiqSans'),
    );
  }
}




