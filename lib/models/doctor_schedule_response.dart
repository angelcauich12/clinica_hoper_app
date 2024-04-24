import 'dart:convert';

class DoctorScheduleResponse {
  int code;
  String estatus;
  String message;
  List<WorkScheduleDoctor> doctorSchedule;

  DoctorScheduleResponse({
    required this.code,
    required this.estatus,
    required this.message,
    required this.doctorSchedule,
  });

  factory DoctorScheduleResponse.fromJson(String str) =>
      DoctorScheduleResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DoctorScheduleResponse.fromMap(Map<String, dynamic> json) =>
      DoctorScheduleResponse(
        code: json["code"],
        estatus: json["estatus"],
        message: json["message"],
        doctorSchedule: List<WorkScheduleDoctor>.from(
            json["doctor_schedule"].map((x) => WorkScheduleDoctor.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "estatus": estatus,
        "message": message,
        "doctor_schedule":
            List<dynamic>.from(doctorSchedule.map((x) => x.toMap())),
      };
}

class WorkScheduleDoctor {
  int id;
  String description;
  String startTime;
  String endTime;
  List<int> daysOfWeek;
  String display;

  WorkScheduleDoctor({
    required this.id,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek,
    required this.display,
  });

  factory WorkScheduleDoctor.fromJson(String str) =>
      WorkScheduleDoctor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WorkScheduleDoctor.fromMap(Map<String, dynamic> json) => WorkScheduleDoctor(
        id: json["id"],
        description: json["description"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        daysOfWeek: List<int>.from(json["daysOfWeek"].map((x) => x)),
        display: json["display"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "startTime": startTime,
        "endTime": endTime,
        "daysOfWeek": List<dynamic>.from(daysOfWeek.map((x) => x)),
        "display": display,
      };
}
