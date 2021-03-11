import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:humedad_suelo/model/humedity_model.dart';
import 'package:humedad_suelo/provider/humedity_provider.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class HumedityData extends StatefulWidget {
  HumedityData({Key key}) : super(key: key);

  @override
  _HumedoityDataState createState() => _HumedoityDataState();
}

class _HumedoityDataState extends State<HumedityData> {
  //final humedityProvider = new HumedityProvider();


  HumedityProvider objHumedityProvider;
  Future<List<HumedityModel>> futureHumedity;

  @override
  void initState() {
    super.initState();
    objHumedityProvider = new HumedityProvider();
    futureHumedity = objHumedityProvider.getHumedityData();

    new Timer.periodic(new Duration(seconds: 5), (Timer t) {
      objHumedityProvider.doUpdate(t);
      setState(() {
        futureHumedity = objHumedityProvider.getHumedityData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de humedad'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    _launchURL('http://192.168.0.126/humedad/dashboard.php');
                  },
                  child: Icon(
                      Icons.web
                  ),
                )
            ),
          ]
      ),

      body: _createListData(),
    );
  }

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'No se pudo iniciar $url';


  Widget _createListData() {
    return FutureBuilder(
        future: futureHumedity,
        builder: (BuildContext context,
            AsyncSnapshot<List<HumedityModel>> snapshot) {
          if (snapshot.hasData) {
            final recordhumedity = snapshot.data;
            return ListView.builder(
                itemCount: recordhumedity.length,
                itemBuilder: (context, int i) =>
                    _cardList(context, recordhumedity[i])
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _createItem(BuildContext context, HumedityModel humedityModel) {
    return ListTile(
      title: Text(
          'Porcentaje: ${humedityModel.percentage}% - Rango: ${humedityModel.rango}'),
      subtitle: Text('Fecha: ${humedityModel.dateTime}'),
    );
  }

  Widget _cardList(BuildContext context, HumedityModel humedityModel)
  {
    double screenWidth = MediaQuery.of(context).size.width;

    final percentageText = Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(0.1, 1, 10, 2),
        alignment: Alignment.centerLeft,
        child: Text(
          '${humedityModel.percentage}% de humedad',
          style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    final rangeText =    Center(
      child: Container(
          padding: EdgeInsets.fromLTRB(0.1, 3, 10, 4),
          alignment: Alignment.centerLeft,
          child: Text(
            'Rango de ${humedityModel.rango}',
            style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                fontFamily: 'Lato',
                fontSize: 12.0,
                fontWeight: FontWeight.bold
            ),
          )
      ),
    );

    final dateText = Center(
      child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          alignment: Alignment.centerLeft,
          child: Text(
            '${humedityModel.dateTime}',
            style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.amber
            ),
          )
      ),
    );

    final card = Container(
      width: screenWidth * 1,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black38,
                blurRadius: 10.0,
                offset: Offset(0.0, 5.0)
            )
          ]
      ),
      child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              percentageText,
              rangeText,
              dateText,
            ],
          )
      ),
    );


    return Stack(
      alignment: Alignment(0.8, 0.5),
      children: <Widget>[
        card,
        _floatingButton(humedityModel.percentage),
      ],
    );
  }

   Widget _floatingButton(int percentage) {
     return FloatingActionButton(
       backgroundColor: percentage > 45 ? Colors.green : Colors.red,
       mini: true,
       tooltip: "Status",
       onPressed: () {},
       child: Icon(percentage > 45 ? Icons.check : Icons.warning_amber_outlined),
     );
   }
}
