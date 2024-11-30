// To parse this JSON data, do
//
//     final cabangModel = cabangModelFromJson(jsonString);

import 'dart:convert';

CabangModel cabangModelFromJson(String str) =>
    CabangModel.fromJson(json.decode(str));

String cabangModelToJson(CabangModel data) => json.encode(data.toJson());

class CabangModel {
  int kodecab;
  String namacab;

  CabangModel({
    required this.kodecab,
    required this.namacab,
  });

  factory CabangModel.fromJson(Map<String, dynamic> json) => CabangModel(
        kodecab: json["kodecab"],
        namacab: json["namacab"],
      );

  Map<String, dynamic> toJson() => {
        "kodecab": kodecab,
        "namacab": namacab,
      };
}
