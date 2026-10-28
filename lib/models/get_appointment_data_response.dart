// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 11/09/2023
 */
import 'dart:convert';

import 'package:hope_app/models/models.dart';

class DataResponse {
  int? code;
  String? status;
  List<Specialty>? specialties;

  DataResponse({
    this.code,
    this.status,
    this.specialties,
  });

  factory DataResponse.fromJson(String str) =>
      DataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataResponse.fromMap(Map<String, dynamic> json) => DataResponse(
        code: json["code"],
        status: json["status"],
        specialties: json["specialties"] == null
            ? []
            : List<Specialty>.from(
                json["specialties"]!.map((x) => Specialty.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "specialties": specialties == null
            ? []
            : List<dynamic>.from(specialties!.map((x) => x.toMap())),
      };
}
