import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:humedad_suelo/model/humedity_model.dart';
import 'package:humedad_suelo/utils/url_server.dart';

class HumedityProvider {
  doUpdate(Timer t) {
    getHumedityData();
  }

  Future<List<HumedityModel>> getHumedityData() async {
    final String url = '${urlServer.url}=get_humedity';
    try {
      var response = await http.get(url,
          headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});

      final jsonHumedity = json.decode(response.body)['humedad'] as List;
      if (jsonHumedity.isNotEmpty) {
        List<HumedityModel> humedityList = jsonHumedity.map((values) =>
            HumedityModel.fromJson(values)).toList();
        return humedityList;
      } else {
        return [];
      }
    }catch(exception){
      //return [];
      print("Warning (List). ${exception.toString()}");
    }
  }
}
