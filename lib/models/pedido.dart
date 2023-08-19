
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class DataPedido {
  DataPedido({
    this.id,
    this.id_usuario,
    this.fecha,
    this.direccion,
    this.total,
    this.estatus,

  });

  int? id;
  int? id_usuario;
  String? fecha;
  String? direccion;
  double? total;
  String? estatus;

  factory DataPedido.fromJson(String str) => DataPedido.fromMap(json.decode(str));

   String toJson() => json.encode(toMap());

  factory DataPedido.fromMap(Map<String, dynamic> json) => DataPedido(
        id: json["_id"],
        id_usuario: json["id_usuario"],
        fecha: json["fecha"],
        direccion: json["direccion"],
        total: json["total"],
        estatus: json["estatus"],
    );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "id_usuario": id_usuario,
        "fecha": fecha,
        "direccion": direccion,
        "total": total,
        "estatus": estatus,
    };

}