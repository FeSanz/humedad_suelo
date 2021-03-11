import 'package:flutter/material.dart';
import 'dart:async';

import 'package:humedad_suelo/pages/home_page.dart';
import 'package:humedad_suelo/pages/humedity_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sensor de listHumedity',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'listHumedity': (BuildContext context) => HumedityData(),
      },
      home: Scaffold(),
    );
  }
}
