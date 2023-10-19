// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 18/10/2023
 */
import 'dart:convert';

import 'package:hope_app/models/models.dart';

class AppointmentResponse {
  int? code;
  String? status;
  bool? success;
  String? message;
  Appointment? appointment;

  AppointmentResponse({
    this.code,
    this.status,
    this.success,
    this.message,
    this.appointment,
  });

  factory AppointmentResponse.fromJson(String str) =>
      AppointmentResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppointmentResponse.fromMap(Map<String, dynamic> json) =>
      AppointmentResponse(
        code: json["code"],
        status: json["status"],
        success: json["success"],
        message: json["message"],
        appointment: json["appointment"] == null
            ? null
            : Appointment.fromMap(json["appointment"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "success": success,
        "message": message,
        "appointment": appointment?.toMap(),
      };
}
