/// Creado por: David Amilcar Flores Castillo
/// el 08/09/2023
import 'dart:convert';

class AuthDataRequest {
  String name;
  String email;
  String image;
  dynamic phone;
  bool isMerge;

  AuthDataRequest({
    required this.name,
    required this.email,
    required this.image,
    required this.phone,
    required this.isMerge,
  });

  factory AuthDataRequest.fromJson(String str) =>
      AuthDataRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthDataRequest.fromMap(Map<String, dynamic> json) => AuthDataRequest(
        name: json["name"],
        email: json["email"],
        image: json["image"],
        phone: json["phone"],
        isMerge: json["is_merge"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "image": image,
        "phone": phone,
        "is_merge": isMerge,
      };
}
