import 'dart:convert';

HumedityModel humedityModelFromJson(String str) =>
    HumedityModel.fromJson(json.decode(str));

String humedityModelToJson(HumedityModel data) => json.encode(data.toJson());

class HumedityModel {
  HumedityModel({
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

  factory HumedityModel.fromJson(Map<String, dynamic> json) => HumedityModel(
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
