// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 30/08/2023
 */
import 'dart:convert';

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
  int id;
  String description;
  String scheduledDate;
  String scheduledTime;
  String scheduledTimeEnd;
  String type;
  int doctorId;
  int specialtyId;
  int patientId;
  List<dynamic> datosCitas;
  int pagado;
  dynamic importe;
  String createdAt;
  String updatedAt;
  int consultingRoomId;
  int statusId;
  Doctor doctor;
  Patient patient;
  dynamic cancellation;
  Specialty specialty;
  Status status;

  Appointment({
    required this.id,
    required this.description,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.scheduledTimeEnd,
    required this.type,
    required this.doctorId,
    required this.specialtyId,
    required this.patientId,
    required this.datosCitas,
    required this.pagado,
    required this.importe,
    required this.createdAt,
    required this.updatedAt,
    required this.consultingRoomId,
    required this.statusId,
    required this.doctor,
    required this.patient,
    required this.cancellation,
    required this.specialty,
    required this.status,
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
        datosCitas: List<dynamic>.from(json["datos_Citas"].map((x) => x)),
        pagado: json["pagado"],
        importe: json["importe"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        consultingRoomId: json["consulting_room_id"],
        statusId: json["status_id"],
        doctor: Doctor.fromMap(json["doctor"]),
        patient: Patient.fromMap(json["patient"]),
        cancellation: json["cancellation"],
        specialty: Specialty.fromMap(json["specialty"]),
        status: Status.fromMap(json["status"]),
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
        "datos_Citas": List<dynamic>.from(datosCitas.map((x) => x)),
        "pagado": pagado,
        "importe": importe,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "consulting_room_id": consultingRoomId,
        "status_id": statusId,
        "doctor": doctor.toMap(),
        "patient": patient.toMap(),
        "cancellation": cancellation,
        "specialty": specialty.toMap(),
        "status": status.toMap(),
      };
}

class Doctor {
  int id;
  String name;
  String lastName;
  String? email;
  String? emailVerifiedAt;
  String? cedula;
  String? address;
  String phone;
  int role;
  String? tokenGoogle;
  String? codeGoogle;
  int status;
  String createdAt;
  String updatedAt;
  List<ConsultingRoom> consultingRooms;

  Doctor({
    required this.id,
    required this.name,
    required this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.cedula,
    this.address,
    required this.phone,
    required this.role,
    this.tokenGoogle,
    this.codeGoogle,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.consultingRooms,
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
        tokenGoogle: json["token_google"],
        codeGoogle: json["code_google"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        consultingRooms: List<ConsultingRoom>.from(
            json["consulting_rooms"].map((x) => ConsultingRoom.fromMap(x))),
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
        "token_google": tokenGoogle,
        "code_google": codeGoogle,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "consulting_rooms":
            List<dynamic>.from(consultingRooms.map((x) => x.toMap())),
      };

  // @override
  // bool operator ==(other) {
  //   return other is Doctor && id == other.id;
  // }

  // @override
  // int get hashCode => id.hashCode;
}

class Patient {
  int id;
  String name;
  String lastName;
  String? email;
  String? emailVerifiedAt;
  String? cedula;
  String? address;
  String phone;
  int role;
  String? tokenGoogle;
  String? codeGoogle;
  int status;
  String createdAt;
  String updatedAt;

  Patient({
    required this.id,
    required this.name,
    required this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.cedula,
    this.address,
    required this.phone,
    required this.role,
    this.tokenGoogle,
    this.codeGoogle,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(String str) => Patient.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Patient.fromMap(Map<String, dynamic> json) => Patient(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        cedula: json["cedula"],
        address: json["address"],
        phone: json["phone"],
        role: json["role"],
        tokenGoogle: json["token_google"],
        codeGoogle: json["code_google"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        "token_google": tokenGoogle,
        "code_google": codeGoogle,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class ConsultingRoom {
  int id;
  String name;
  String idGoogleCalendar;
  String createdAt;
  String updatedAt;
  Pivot pivot;

  ConsultingRoom({
    required this.id,
    required this.name,
    required this.idGoogleCalendar,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
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
        pivot: Pivot.fromMap(json["pivot"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "id_google_calendar": idGoogleCalendar,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "pivot": pivot.toMap(),
      };
}

class Pivot {
  int userId;
  int consultingRoomId;
  String createdAt;
  String updatedAt;

  Pivot({
    required this.userId,
    required this.consultingRoomId,
    required this.createdAt,
    required this.updatedAt,
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
  int id;
  String name;
  dynamic description;
  String createdAt;
  String updatedAt;
  List<Doctor>? doctors;

  Specialty({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
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
  int id;
  String name;
  dynamic descripcion;

  Status({
    required this.id,
    required this.name,
    required this.descripcion,
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
