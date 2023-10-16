// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 11/09/2023
 */
import 'dart:convert';

class ScheduleIntervalsResponse {
  int? code;
  String? status;
  DoctorSchedule? doctorSchedule;

  ScheduleIntervalsResponse({
    this.code,
    this.status,
    this.doctorSchedule,
  });

  factory ScheduleIntervalsResponse.fromJson(String str) =>
      ScheduleIntervalsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScheduleIntervalsResponse.fromMap(Map<String, dynamic> json) =>
      ScheduleIntervalsResponse(
        code: json["code"],
        status: json["status"],
        doctorSchedule: json["doctor_schedule"] == null
            ? null
            : DoctorSchedule.fromMap(json["doctor_schedule"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "doctor_schedule": doctorSchedule?.toMap(),
      };
}

class DoctorSchedule {
  int? id;
  int? day;
  int? active;
  String? morningStart;
  String? morningEnd;
  String? afternoonStart;
  String? afternoonEnd;
  int? userId;
  String? createdAt;
  String? updatedAt;
  List<String>? morningIntervals;
  List<String>? afternoonIntervals;

  DoctorSchedule({
    this.id,
    this.day,
    this.active,
    this.morningStart,
    this.morningEnd,
    this.afternoonStart,
    this.afternoonEnd,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.morningIntervals,
    this.afternoonIntervals,
  });

  factory DoctorSchedule.fromJson(String str) =>
      DoctorSchedule.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DoctorSchedule.fromMap(Map<String, dynamic> json) => DoctorSchedule(
        id: json["id"],
        day: json["day"],
        active: json["active"],
        morningStart: json["morning_start"],
        morningEnd: json["morning_end"],
        afternoonStart: json["afternoon_start"],
        afternoonEnd: json["afternoon_end"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        morningIntervals: json["morning_intervals"] == null
            ? []
            : List<String>.from(json["morning_intervals"]!.map((x) => x)),
        afternoonIntervals: json["afternoon_intervals"] == null
            ? []
            : List<String>.from(json["afternoon_intervals"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "day": day,
        "active": active,
        "morning_start": morningStart,
        "morning_end": morningEnd,
        "afternoon_start": afternoonStart,
        "afternoon_end": afternoonEnd,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "morning_intervals": morningIntervals == null
            ? []
            : List<dynamic>.from(morningIntervals!.map((x) => x)),
        "afternoon_intervals": afternoonIntervals == null
            ? []
            : List<dynamic>.from(afternoonIntervals!.map((x) => x)),
      };
}
