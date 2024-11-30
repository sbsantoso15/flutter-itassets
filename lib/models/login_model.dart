// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String userid;
  String username;

  LoginModel({
    required this.userid,
    required this.username,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        userid: json["userid"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "username": username,
      };
}
