import 'dart:convert';

CurrentHumedityModel currentHumedityModelFromJson(String str) =>
    CurrentHumedityModel.fromJson(json.decode(str));

String currentHumedityModelToJson(CurrentHumedityModel data) =>
    json.encode(data.toJson());

class CurrentHumedityModel {
  CurrentHumedityModel({
    this.id,
    this.plant,
    this.dateTime,
    this.rango,
    this.percentage,
  });

  int id;
  String plant;
  String dateTime;
  int rango;
  int percentage;

  factory CurrentHumedityModel.fromJson(Map<String, dynamic> json) =>
      CurrentHumedityModel(
        id: json["id"],
        plant: json["plant"],
        dateTime: json["date_time"],
        rango: json["rango"],
        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plant": plant,
        "date_time": dateTime,
        "rango": rango,
        "percentage": percentage,
      };
}
