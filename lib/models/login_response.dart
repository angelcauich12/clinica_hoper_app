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
    required this.isGoogle,
    required this.createdAt,
    this.deviceToken,
    required this.miPerfil,
  });

  int id;
  String name;
  String lastname;
  String email;
  String? image;
  int role;
  String? phone;
  int status;
  int isGoogle;
  String createdAt;
  String? deviceToken;
  MiPerfil miPerfil;

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
