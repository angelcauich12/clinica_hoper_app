/// Creado por: David Amilcar Flores Castillo
/// el 11/10/2023

import 'dart:convert';

import 'package:hope_app/models/models.dart';

class CreateUserResponse {
  int? code;
  String? status;
  bool? success;
  User? user;

  CreateUserResponse({
    this.code,
    this.status,
    this.success,
    this.user,
  });

  factory CreateUserResponse.fromJson(String str) =>
      CreateUserResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateUserResponse.fromMap(Map<String, dynamic> json) =>
      CreateUserResponse(
        code: json["code"],
        status: json["status"],
        success: json["success"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "success": success,
        "user": user?.toMap(),
      };
}
