// ignore: slash_for_doc_comments
/**
 * Creado por: David Amilcar Flores Castillo
 * el 30/08/2023
 */
import 'dart:convert';

class ConfirmAppointment {
  String id;

  ConfirmAppointment({
    required this.id,
  });

  factory ConfirmAppointment.fromJson(String str) =>
      ConfirmAppointment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConfirmAppointment.fromMap(Map<String, dynamic> json) =>
      ConfirmAppointment(
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
      };
}
