import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:humedad_suelo/model/current_ humedity_model.dart';

import 'dart:async';

import 'package:humedad_suelo/utils/url_server.dart';

class CurrentHumedityProvider {
  doUpdate(Timer t) {
    getCurrentHumedityData();
  }

  Future<List<CurrentHumedityModel>> getCurrentHumedityData() async {
    final String url = '${urlServer.url}=get_current_humedity';

    try {
      var response = await http.get(url,
          headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});

     /* Map<String, dynamic> decodeData = json.decode(response.body);
      final List<CurrentHumedityModel> humedityList = new List();

      if (decodeData == null) return [];

      final hum = CurrentHumedityModel.fromJson(decodeData["current"][0]);
      humedityList.add(hum);*/

      final jsonCurrentHumedity = json.decode(response.body)['current'] as List;
      if (jsonCurrentHumedity.isNotEmpty) {
        List<CurrentHumedityModel> currentHumedityList = jsonCurrentHumedity.map((values) =>
            CurrentHumedityModel.fromJson(values)).toList();
        return currentHumedityList;
      } else {
        return [];
      }
      //print(hum.rango.toString());
      //return humedityList;
    }catch(exception){
      //return [];
      print("Warning (Guage). ${exception.toString()}");
    }
  }
}
