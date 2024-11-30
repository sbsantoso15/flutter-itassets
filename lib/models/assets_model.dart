// To parse this JSON data, do
//
//     final assetsModel = assetsModelFromJson(jsonString);

import 'dart:convert';

AssetsModel assetsModelFromJson(String str) =>
    AssetsModel.fromJson(json.decode(str));

String assetsModelToJson(AssetsModel data) => json.encode(data.toJson());

class AssetsModel {
  String noseri;
  int kodecab;
  String hwcode;
  String merk;
  String hwtype;
  String kapasitas;
  String keterangan;
  int isactive;

  AssetsModel({
    required this.noseri,
    required this.kodecab,
    required this.hwcode,
    required this.merk,
    required this.hwtype,
    required this.kapasitas,
    required this.keterangan,
    required this.isactive,
  });

  factory AssetsModel.fromJson(Map<String, dynamic> json) => AssetsModel(
        noseri: json["noseri"],
        kodecab: json["kodecab"],
        hwcode: json["hwcode"],
        merk: json["merk"],
        hwtype: json["hwtype"],
        kapasitas: json["kapasitas"],
        keterangan: json["keterangan"],
        isactive: json["isactive"],
      );

  Map<String, dynamic> toJson() => {
        "noseri": noseri,
        "kodecab": kodecab,
        "hwcode": hwcode,
        "merk": merk,
        "hwtype": hwtype,
        "kapasitas": kapasitas,
        "keterangan": keterangan,
        "isactive": isactive,
      };
}
