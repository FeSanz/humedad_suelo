import 'package:flutter/material.dart';
import 'package:humedad_suelo/pages/background_home.dart';
import 'package:humedad_suelo/pages/user_info.dart';
import 'package:humedad_suelo/provider/current_%20humedity_provider.dart';
//import 'package:graphic/graphic.dart' as graphic;
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:humedad_suelo/model/current_ humedity_model.dart';
import 'dart:async';

//import 'data.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  double screenHeight, screenWidth;

  final humedityProvider = new CurrentHumedityProvider();

  double range = 0.0, percentage = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(
      children: [
        BackgroundHome(),
        _headerPage(),
        getCurrentData(),
        _createButton(context)
      ],
    ));
  }

  Widget _headerPage() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Acuaponía',
                style: TextStyle(
                    fontFamily: 'Lato',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0),
                textAlign: TextAlign.right,
              )
            ],
          ),
          UserInfo('assets/img/condor_logo.png', 'Sensor de humedad del suelo',
              'Internet of Things by SPACE'),
          //ButtonsBar()
        ],
      ),
    );
  }

  Widget getCurrentData() {
    return FutureBuilder(
        future: humedityProvider.getCurrentHumedityData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CurrentHumedityModel>> snapshot) {
          if (snapshot.hasData) {
            final recordhumedity = snapshot.data;
            percentage = double.parse(recordhumedity[0].percentage.toString());
            range = double.parse(recordhumedity[0].rango.toString());

            new Timer.periodic(new Duration(seconds: 5), (Timer t) {
              CurrentHumedityProvider().doUpdate(t);
              setState(() {
                percentage = double.parse(recordhumedity[0].percentage.toString());
                range = double.parse(recordhumedity[0].rango.toString());
              });
            });
            return  Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
              child: ListView(
                children: [
                  currentHumedityPercentageGuange('Porcentaje de humedad actual', percentage),
                  currentHumedityRangeGuange('Rango de humedad actual', range)
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget currentHumedityPercentageGuange(String title, double range) {
    return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 170.0),
        width: screenWidth * 0.90,
        height: screenHeight * 0.35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 5.0))
            ]),
        child: SfRadialGauge(
        title: GaugeTitle(
            text: title,
            textStyle:
                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 45,
                color: Colors.red,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 45,
                endValue: 70,
                color: Colors.blueGrey,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 70,
                endValue: 100,
                color: Colors.blue,
                startWidth: 10,
                endWidth: 10)
          ], pointers: <GaugePointer>[
            NeedlePointer(value: range)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child: Text(range.toString(),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]));
  }

  Widget currentHumedityRangeGuange(String title, double range) {
    return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
    width: screenWidth * 0.90,
    height: screenHeight * 0.35,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    color: Colors.white,
    boxShadow: <BoxShadow>[
    BoxShadow(
    color: Colors.black38,
    blurRadius: 10.0,
    offset: Offset(0.0, 5.0))
    ]),
    child:  SfRadialGauge(
        title: GaugeTitle(
            text: title,
            textStyle:
                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 1023, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 256,
                color: Colors.blueAccent,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 256,
                endValue: 512,
                color: Colors.blueGrey,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 512,
                endValue: 768,
                color: Colors.orange,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 768,
                endValue: 1023,
                color: Colors.red,
                startWidth: 10,
                endWidth: 10)
          ], pointers: <GaugePointer>[
            NeedlePointer(value: range)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child: Text(range.toString(),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]));
  }

  Widget _createButton(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          mini: true,
          tooltip: "Data",
          onPressed: (){
            Navigator.pushNamed(context, 'listHumedity');
          },
          child: Icon(
              Icons.add_chart
          ),
        ),
      ),
    );
  }
}
