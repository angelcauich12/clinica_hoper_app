// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 30/08/2023
 */
import 'dart:convert';

import 'package:hope_app/models/models.dart';

class MyAppointments {
  int code;
  String status;
  List<Appointment> appointments;
  int role;

  MyAppointments({
    required this.code,
    required this.status,
    required this.appointments,
    required this.role,
  });

  factory MyAppointments.fromJson(String str) =>
      MyAppointments.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyAppointments.fromMap(Map<String, dynamic> json) => MyAppointments(
        code: json["code"],
        status: json["status"],
        appointments: List<Appointment>.from(
            json["Appointments"].map((x) => Appointment.fromMap(x))),
        role: json["role"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "Appointments": List<dynamic>.from(appointments.map((x) => x.toMap())),
        "role": role,
      };
}

class Appointment {
  int? id;
  String? description;
  String? scheduledDate;
  String? scheduledTime;
  String? scheduledTimeEnd;
  String? type;
  int? doctorId;
  int? specialtyId;
  int? patientId;
  List<dynamic>? datosCitas;
  int? pagado;
  int? corteCaja;
  String? importe;
  String? createdAt;
  String? updatedAt;
  int? consultingRoomId;
  int? statusId;
  Doctor? doctor;
  Doctor? patient;
  Cancellation? cancellation;
  Specialty? specialty;
  Status? status;

  Appointment({
    this.id,
    this.description,
    this.scheduledDate,
    this.scheduledTime,
    this.scheduledTimeEnd,
    this.type,
    this.doctorId,
    this.specialtyId,
    this.patientId,
    this.datosCitas,
    this.pagado,
    this.corteCaja,
    this.importe,
    this.createdAt,
    this.updatedAt,
    this.consultingRoomId,
    this.statusId,
    this.doctor,
    this.patient,
    this.cancellation,
    this.specialty,
    this.status,
  });

  factory Appointment.fromJson(String str) =>
      Appointment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Appointment.fromMap(Map<String, dynamic> json) => Appointment(
        id: json["id"],
        description: json["description"],
        scheduledDate: json["scheduled_date"],
        scheduledTime: json["scheduled_time"],
        scheduledTimeEnd: json["scheduled_time_end"],
        type: json["type"],
        doctorId: json["doctor_id"],
        specialtyId: json["specialty_id"],
        patientId: json["patient_id"],
        datosCitas: json["datos_Citas"] == null
            ? []
            : List<dynamic>.from(json["datos_Citas"]!.map((x) => x)),
        pagado: json["pagado"],
        corteCaja: json["corte_caja"],
        importe: json["importe"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        consultingRoomId: json["consulting_room_id"],
        statusId: json["status_id"],
        doctor: json["doctor"] == null ? null : Doctor.fromMap(json["doctor"]),
        patient:
            json["patient"] == null ? null : Doctor.fromMap(json["patient"]),
        cancellation: json["cancellation"] == null
            ? null
            : Cancellation.fromMap(json["cancellation"]),
        specialty: json["specialty"] == null
            ? null
            : Specialty.fromMap(json["specialty"]),
        status: json["status"] == null ? null : Status.fromMap(json["status"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "scheduled_date": scheduledDate,
        "scheduled_time": scheduledTime,
        "scheduled_time_end": scheduledTimeEnd,
        "type": type,
        "doctor_id": doctorId,
        "specialty_id": specialtyId,
        "patient_id": patientId,
        "datos_Citas": datosCitas == null
            ? []
            : List<dynamic>.from(datosCitas!.map((x) => x)),
        "pagado": pagado,
        "corte_caja": corteCaja,
        "importe": importe,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "consulting_room_id": consultingRoomId,
        "status_id": statusId,
        "doctor": doctor?.toMap(),
        "patient": patient?.toMap(),
        "cancellation": cancellation?.toMap(),
        "specialty": specialty?.toMap(),
        "status": status?.toMap(),
      };
}

class Cancellation {
  int? id;
  int? appointmentId;
  String? justification;
  int? cancelledById;
  String? createdAt;
  String? updatedAt;
  Doctor? cancelledBy;

  Cancellation({
    this.id,
    this.appointmentId,
    this.justification,
    this.cancelledById,
    this.createdAt,
    this.updatedAt,
    this.cancelledBy,
  });

  factory Cancellation.fromJson(String str) =>
      Cancellation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cancellation.fromMap(Map<String, dynamic> json) => Cancellation(
        id: json["id"],
        appointmentId: json["appointment_id"],
        justification: json["justification"],
        cancelledById: json["cancelled_by_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        cancelledBy: json["cancelled_by"] == null
            ? null
            : Doctor.fromMap(json["cancelled_by"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "appointment_id": appointmentId,
        "justification": justification,
        "cancelled_by_id": cancelledById,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "cancelled_by": cancelledBy?.toMap(),
      };
}

class Doctor {
  int? id;
  String? name;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  String? cedula;
  String? address;
  String? phone;
  int? role;
  dynamic image;
  dynamic tokenGoogle;
  dynamic codeGoogle;
  int? isGoogle;
  int? isApple;
  int? isFacebook;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<ConsultingRoom>? consultingRooms;
  MedicalHistory? medicalHistory;

  Doctor({
    this.id,
    this.name,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.cedula,
    this.address,
    this.phone,
    this.role,
    this.image,
    this.tokenGoogle,
    this.codeGoogle,
    this.isGoogle,
    this.isApple,
    this.isFacebook,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.consultingRooms,
    this.medicalHistory,
  });

  factory Doctor.fromJson(String str) => Doctor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Doctor.fromMap(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        cedula: json["cedula"],
        address: json["address"],
        phone: json["phone"],
        role: json["role"],
        image: json["image"],
        tokenGoogle: json["token_google"],
        codeGoogle: json["code_google"],
        isGoogle: json["is_google"],
        isApple: json["is_apple"],
        isFacebook: json["is_facebook"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        consultingRooms: json["consulting_rooms"] == null
            ? []
            : List<ConsultingRoom>.from(json["consulting_rooms"]!
                .map((x) => ConsultingRoom.fromMap(x))),
        medicalHistory: json["medical_history"] == null
            ? null
            : MedicalHistory.fromMap(json["medical_history"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "cedula": cedula,
        "address": address,
        "phone": phone,
        "role": role,
        "image": image,
        "token_google": tokenGoogle,
        "code_google": codeGoogle,
        "is_google": isGoogle,
        "is_apple": isApple,
        "is_facebook": isFacebook,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "consulting_rooms": consultingRooms == null
            ? []
            : List<dynamic>.from(consultingRooms!.map((x) => x.toMap())),
        "medical_history": medicalHistory?.toMap(),
      };
}

class ConsultingRoom {
  int? id;
  String? name;
  String? idGoogleCalendar;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  ConsultingRoom({
    this.id,
    this.name,
    this.idGoogleCalendar,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory ConsultingRoom.fromJson(String str) =>
      ConsultingRoom.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConsultingRoom.fromMap(Map<String, dynamic> json) => ConsultingRoom(
        id: json["id"],
        name: json["name"],
        idGoogleCalendar: json["id_google_calendar"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        pivot: json["pivot"] == null ? null : Pivot.fromMap(json["pivot"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "id_google_calendar": idGoogleCalendar,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "pivot": pivot?.toMap(),
      };
}

class Pivot {
  int? userId;
  int? consultingRoomId;
  String? createdAt;
  String? updatedAt;

  Pivot({
    this.userId,
    this.consultingRoomId,
    this.createdAt,
    this.updatedAt,
  });

  factory Pivot.fromJson(String str) => Pivot.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pivot.fromMap(Map<String, dynamic> json) => Pivot(
        userId: json["user_id"],
        consultingRoomId: json["consulting_room_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "consulting_room_id": consultingRoomId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Specialty {
  int? id;
  String? name;
  dynamic description;
  String? createdAt;
  String? updatedAt;
  List<Doctor>? doctors;

  Specialty({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.doctors,
  });

  factory Specialty.fromJson(String str) => Specialty.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Specialty.fromMap(Map<String, dynamic> json) => Specialty(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        doctors: json["doctors"] == null
            ? []
            : List<Doctor>.from(json["doctors"]!.map((x) => Doctor.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "doctors": doctors == null
            ? []
            : List<dynamic>.from(doctors!.map((x) => x.toMap())),
      };
}

class Status {
  int? id;
  String? name;
  dynamic descripcion;

  Status({
    this.id,
    this.name,
    this.descripcion,
  });

  factory Status.fromJson(String str) => Status.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Status.fromMap(Map<String, dynamic> json) => Status(
        id: json["id"],
        name: json["name"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "descripcion": descripcion,
      };
}

class AppointmentCreatedResponse {
  int? code;
  String? status;
  Appointment? appointment;
  String? message;
  String? conexion;

  AppointmentCreatedResponse({
    this.code,
    this.status,
    this.appointment,
    this.message,
    this.conexion,
  });

  factory AppointmentCreatedResponse.fromJson(String str) =>
      AppointmentCreatedResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppointmentCreatedResponse.fromMap(Map<String, dynamic> json) =>
      AppointmentCreatedResponse(
        code: json["code"],
        status: json["status"],
        appointment: json["appointment"] == null
            ? null
            : Appointment.fromMap(json["appointment"]),
        message: json["message"],
        conexion: json["conexion"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "appointment": appointment?.toMap(),
        "message": message,
        "conexion": conexion,
      };
}
