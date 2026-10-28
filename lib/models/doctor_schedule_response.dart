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

  factory DoctorScheduleResponse.fromJson(String str) => DoctorScheduleResponse.fromMap(json.decode(str));

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


class NonWorkingDaysResponse {
    int code;
    String estatus;
    String message;
    List<NonWorkingDay> nonWorkingDays;

    NonWorkingDaysResponse({
       required this.code,
       required this.estatus,
       required this.message,
       required this.nonWorkingDays,
    });

    factory NonWorkingDaysResponse.fromJson(String str) => NonWorkingDaysResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory NonWorkingDaysResponse.fromMap(Map<String, dynamic> json) => NonWorkingDaysResponse(
        code: json["code"],
        estatus: json["estatus"],
        message: json["message"],
        nonWorkingDays: List<NonWorkingDay>.from(json["non_working_days"]!.map((x) => NonWorkingDay.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "code": code,
        "estatus": estatus,
        "message": message,
        "non_working_days": List<dynamic>.from(nonWorkingDays.map((x) => x.toMap())),
    };
}

class NonWorkingDay {
    int id;
    String title;
    String description;
    String start;
    String end;
    String backgroundColor;
    String display;

    NonWorkingDay({
       required this.id,
       required this.title,
       required this.description,
       required this.start,
       required this.end,
       required this.backgroundColor,
       required this.display,
    });

    factory NonWorkingDay.fromJson(String str) => NonWorkingDay.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory NonWorkingDay.fromMap(Map<String, dynamic> json) => NonWorkingDay(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        start: json["start"],
        end: json["end"],
        backgroundColor: json["backgroundColor"],
        display: json["display"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "start": start,
        "end": end,
        "backgroundColor": backgroundColor,
        "display": display,
    };
}




class CreateNonWorkingResponse {
    int code;
    String estatus;
    String message;
    NonWorkingDay nonWorkingDay;

    CreateNonWorkingResponse({
        required this.code,
        required this.estatus,
        required this.message,
        required this.nonWorkingDay,
    });

    factory CreateNonWorkingResponse.fromJson(String str) => CreateNonWorkingResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreateNonWorkingResponse.fromMap(Map<String, dynamic> json) => CreateNonWorkingResponse(
        code: json["code"],
        estatus: json["estatus"],
        message: json["message"],
        nonWorkingDay: NonWorkingDay.fromMap(json["non_working_day"]),
    );

    Map<String, dynamic> toMap() => {
        "code": code,
        "estatus": estatus,
        "message": message,
        "non_working_day": nonWorkingDay.toMap(),
    };
}





