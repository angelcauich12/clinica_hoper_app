/// Creado por: David Amilcar Flores Castillo
/// el 18/09/2023

import 'dart:convert';

import 'package:hope_app/models/models.dart';

class MedicalRecordsRequest {
  String? fechaNacimiento;
  int? edad;
  String? genero;
  String? ocupacion;
  String? estadoCivil;
  String? domicilio;
  String? ciudad;
  String? estado;
  String? codigoPostal;
  String? telefono;
  String? celular;
  String? horarioContacto;
  String? contactoNombre;
  String? contactoParentesco;
  String? contactoTelefono;
  String? contactoCelular;
  String? medicamentosTextarea;
  String? alergiasTextarea;
  dynamic motivoConsulta;
  dynamic alertas;
  dynamic otrasAlteraciones;
  dynamic firma;
  int? tomaMedicamentos;
  int? alergias;
  int? cardiopatias;
  int? coagulopatias;
  int? alteracionPresionArterial;
  int? embarazo;
  int? diabetes;
  int? hepatitis;
  int? fiebreReumatica;
  int? enfermedadesRenales;
  int? inmunosupresion;
  int? trastornosRespiratorios;
  int? trastornosGastricos;
  int? epilepsia;
  int? bebeAlcohol;
  int? fuma;
  String? createdAt;
  String? updatedAt;

  MedicalRecordsRequest({
    this.fechaNacimiento,
    this.edad,
    this.genero,
    this.ocupacion,
    this.estadoCivil,
    this.domicilio,
    this.ciudad,
    this.estado,
    this.codigoPostal,
    this.telefono,
    this.celular,
    this.horarioContacto,
    this.contactoNombre,
    this.contactoParentesco,
    this.contactoTelefono,
    this.contactoCelular,
    this.medicamentosTextarea,
    this.alergiasTextarea,
    this.motivoConsulta,
    this.alertas,
    this.otrasAlteraciones,
    this.firma,
    this.tomaMedicamentos,
    this.alergias,
    this.cardiopatias,
    this.coagulopatias,
    this.alteracionPresionArterial,
    this.embarazo,
    this.diabetes,
    this.hepatitis,
    this.fiebreReumatica,
    this.enfermedadesRenales,
    this.inmunosupresion,
    this.trastornosRespiratorios,
    this.trastornosGastricos,
    this.epilepsia,
    this.bebeAlcohol,
    this.fuma,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicalRecordsRequest.fromJson(String str) =>
      MedicalRecordsRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MedicalRecordsRequest.fromMap(Map<String, dynamic> json) =>
      MedicalRecordsRequest(
        fechaNacimiento: json["fecha_nacimiento"],
        edad: json["edad"],
        genero: json["genero"],
        ocupacion: json["ocupacion"],
        estadoCivil: json["estado_civil"],
        domicilio: json["domicilio"],
        ciudad: json["ciudad"],
        estado: json["estado"],
        codigoPostal: json["codigo_postal"],
        telefono: json["telefono"],
        celular: json["celular"],
        horarioContacto: json["horario_contacto"],
        contactoNombre: json["contacto_nombre"],
        contactoParentesco: json["contacto_parentesco"],
        contactoTelefono: json["contacto_telefono"],
        contactoCelular: json["contacto_celular"],
        medicamentosTextarea: json["medicamentos_textarea"],
        alergiasTextarea: json["alergias_textarea"],
        motivoConsulta: json["motivo_consulta"],
        alertas: json["alertas"],
        otrasAlteraciones: json["otras_alteraciones"],
        firma: json["firma"],
        tomaMedicamentos: json["toma_medicamentos"],
        alergias: json["alergias"],
        cardiopatias: json["cardiopatias"],
        coagulopatias: json["coagulopatias"],
        alteracionPresionArterial: json["alteracion_presion_arterial"],
        embarazo: json["embarazo"],
        diabetes: json["diabetes"],
        hepatitis: json["hepatitis"],
        fiebreReumatica: json["fiebre_reumatica"],
        enfermedadesRenales: json["enfermedades_renales"],
        inmunosupresion: json["inmunosupresion"],
        trastornosRespiratorios: json["trastornos_respiratorios"],
        trastornosGastricos: json["trastornos_gastricos"],
        epilepsia: json["epilepsia"],
        bebeAlcohol: json["bebe_alcohol"],
        fuma: json["fuma"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "fecha_nacimiento": fechaNacimiento,
        "edad": edad,
        "genero": genero,
        "ocupacion": ocupacion,
        "estado_civil": estadoCivil,
        "domicilio": domicilio,
        "ciudad": ciudad,
        "estado": estado,
        "codigo_postal": codigoPostal,
        "telefono": telefono,
        "celular": celular,
        "horario_contacto": horarioContacto,
        "contacto_nombre": contactoNombre,
        "contacto_parentesco": contactoParentesco,
        "contacto_telefono": contactoTelefono,
        "contacto_celular": contactoCelular,
        "motivo_consulta": motivoConsulta,
        "medicamentos_textarea": medicamentosTextarea,
        "alergias_textarea": alergiasTextarea,
        "alertas": alertas,
        "otras_alteraciones": otrasAlteraciones,
        "firma": firma,
        "toma_medicamentos": tomaMedicamentos,
        "alergias": alergias,
        "cardiopatias": cardiopatias,
        "coagulopatias": coagulopatias,
        "alteracion_presion_arterial": alteracionPresionArterial,
        "embarazo": embarazo,
        "diabetes": diabetes,
        "hepatitis": hepatitis,
        "fiebre_reumatica": fiebreReumatica,
        "enfermedades_renales": enfermedadesRenales,
        "inmunosupresion": inmunosupresion,
        "trastornos_respiratorios": trastornosRespiratorios,
        "trastornos_gastricos": trastornosGastricos,
        "epilepsia": epilepsia,
        "bebe_alcohol": bebeAlcohol,
        "fuma": fuma,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class MedicalRecordsResponse {
  int? code;
  String? status;
  bool? success;
  String? message;
  MedicalHistory? medicalHistory;

  MedicalRecordsResponse({
    this.code,
    this.status,
    this.success,
    this.message,
    this.medicalHistory,
  });

  factory MedicalRecordsResponse.fromJson(String str) =>
      MedicalRecordsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MedicalRecordsResponse.fromMap(Map<String, dynamic> json) =>
      MedicalRecordsResponse(
        code: json["code"],
        status: json["status"],
        success: json["success"],
        message: json["message"],
        medicalHistory: json["medical_history"] == null
            ? null
            : MedicalHistory.fromMap(json["medical_history"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "success": success,
        "message": message,
        "medical_history": medicalHistory?.toMap(),
      };
}
