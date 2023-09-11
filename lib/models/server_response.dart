// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 22/11/2022
 */

import 'dart:convert';

class ServerResponse {
  ServerResponse({
    this.code,
    this.status,
    this.message,
    this.success,
  });

  int? code;
  String? status;
  String? message;
  bool? success;

  factory ServerResponse.fromJson(String str) =>
      ServerResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServerResponse.fromMap(Map<String, dynamic> json) => ServerResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "message": message,
        "success": success,
      };
}

class ValidatorResponse {
  ValidatorResponse({
    required this.message,
    required this.errors,
  });

  String message;
  Errors errors;

  factory ValidatorResponse.fromJson(String str) =>
      ValidatorResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ValidatorResponse.fromMap(Map<String, dynamic> json) =>
      ValidatorResponse(
        message: json["message"],
        errors: Errors.fromMap(json["errors"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "errors": errors.toMap(),
      };
}

class Errors {
  List<String>? id;
  List<String>? name;
  List<String>? email;
  List<String>? image;
  List<String>? phone;
  List<String>? isMerge;
  List<String>? justification;

  Errors({
    this.id,
    this.name,
    this.email,
    this.image,
    this.phone,
    this.isMerge,
    this.justification,
  });

  factory Errors.fromJson(String str) => Errors.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Errors.fromMap(Map<String, dynamic> json) => Errors(
        id: json["id"] == null
            ? []
            : List<String>.from(json["id"]!.map((x) => x)),
        isMerge: json["is_merge"] == null
            ? []
            : List<String>.from(json["is_merge"]!.map((x) => x)),
        name: json["name"] == null
            ? []
            : List<String>.from(json["name"]!.map((x) => x)),
        email: json["email"] == null
            ? []
            : List<String>.from(json["email"]!.map((x) => x)),
        image: json["image"] == null
            ? []
            : List<String>.from(json["image"]!.map((x) => x)),
        phone: json["phone"] == null
            ? []
            : List<String>.from(json["phone"]!.map((x) => x)),
        justification: json["justification"] == null
            ? []
            : List<String>.from(json["justification"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
        "is_merge":
            isMerge == null ? [] : List<dynamic>.from(isMerge!.map((x) => x)),
        "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
        "email": email == null ? [] : List<dynamic>.from(email!.map((x) => x)),
        "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
        "phone": phone == null ? [] : List<dynamic>.from(phone!.map((x) => x)),
        "justification": justification == null
            ? []
            : List<dynamic>.from(justification!.map((x) => x)),
      };
}

class UnauthenticatedResponse {
  UnauthenticatedResponse({
    required this.message,
  });

  String message;

  factory UnauthenticatedResponse.fromJson(String str) =>
      UnauthenticatedResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnauthenticatedResponse.fromMap(Map<String, dynamic> json) =>
      UnauthenticatedResponse(
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
      };
}
