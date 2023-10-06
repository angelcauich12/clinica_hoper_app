// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 05/10/2023
 */

import 'dart:convert';

import 'package:hope_app/models/models.dart';

class SearchUserResponse {
  int code;
  String status;
  List<User> results;

  SearchUserResponse({
    required this.code,
    required this.status,
    required this.results,
  });

  factory SearchUserResponse.fromJson(String str) =>
      SearchUserResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchUserResponse.fromMap(Map<String, dynamic> json) =>
      SearchUserResponse(
        code: json["code"],
        status: json["status"],
        results: json["results"] == null
            ? []
            : List<User>.from(json["results"]!.map((x) => User.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toMap())),
      };
}
