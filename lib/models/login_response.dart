/// Creado por: David Amilcar Flores Castillo
/// el 22/11/2022

import 'dart:convert';

class LoginResponse {
  LoginResponse({
    required this.code,
    required this.status,
    required this.success,
    required this.user,
    required this.exp,
  });

  int code;
  String status;
  bool success;
  User user;
  int exp;

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        code: json["code"],
        status: json["status"],
        success: json["success"],
        user: User.fromMap(json["user"]),
        exp: json["exp"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "success": success,
        "user": user.toMap(),
        "exp": exp,
      };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.role,
    this.phone,
    this.image,
    required this.status,
    this.isGoogle,
    required this.createdAt,
    this.deviceToken,
    required this.miPerfil,
    this.medicalHistory,
  });

  int id;
  String name;
  String lastname;
  String email;
  String? image;
  int role;
  String? phone;
  int status;
  int? isGoogle;
  String createdAt;
  String? deviceToken;
  MiPerfil miPerfil;
  MedicalHistory? medicalHistory;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"] ?? '',
        email: json["email"],
        image: json["image"],
        role: json["role"],
        phone: json["phone"],
        status: json["status"],
        isGoogle: json["is_google"],
        createdAt: json["created_at"],
        deviceToken: json["device_token"],
        miPerfil: MiPerfil.fromMap(json["mi_perfil"]),
        medicalHistory: json["medical_history"] == null
            ? null
            : MedicalHistory.fromMap(json["medical_history"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "email": email,
        "image": image,
        "role": role,
        "phone": phone,
        "status": status,
        "is_google": isGoogle,
        "created_at": createdAt,
        "device_token": deviceToken,
        "mi_perfil": miPerfil.toMap(),
        "medical_history": medicalHistory?.toMap(),
      };
}

class MiPerfil {
  MiPerfil({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.visible,
    required this.estatus,
  });

  int id;
  String nombre;
  String? descripcion;
  int visible;
  int estatus;

  factory MiPerfil.fromJson(String str) => MiPerfil.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MiPerfil.fromMap(Map<String, dynamic> json) => MiPerfil(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        visible: json["visible"],
        estatus: json["estatus"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "visible": visible,
        "estatus": estatus,
      };
}

class MedicalHistory {
  int? id;
  int? patientId;
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

  MedicalHistory({
    this.id,
    this.patientId,
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

  factory MedicalHistory.fromJson(String str) =>
      MedicalHistory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MedicalHistory.fromMap(Map<String, dynamic> json) => MedicalHistory(
        id: json["id"],
        patientId: json["patient_id"],
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
        "id": id,
        "patient_id": patientId,
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
        "medicamentos_textarea": medicamentosTextarea,
        "alergias_textarea": alergiasTextarea,
        "motivo_consulta": motivoConsulta,
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
