// To parse this JSON data, do
//
//     final jmlPcModel = jmlPcModelFromJson(jsonString);

import 'dart:convert';

JmlPcModel jmlPcModelFromJson(String str) =>
    JmlPcModel.fromJson(json.decode(str));

String jmlPcModelToJson(JmlPcModel data) => json.encode(data.toJson());

class JmlPcModel {
  int domain;
  int nondomain;
  int total;

  JmlPcModel({
    required this.domain,
    required this.nondomain,
    required this.total,
  });

  factory JmlPcModel.fromJson(Map<String, dynamic> json) => JmlPcModel(
        domain: json["domain"],
        nondomain: json["nondomain"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "domain": domain,
        "nondomain": nondomain,
        "total": total,
      };
}
