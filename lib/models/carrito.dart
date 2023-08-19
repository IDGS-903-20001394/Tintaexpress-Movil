
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class DataCarrito {
  DataCarrito({
    this.id,
    this.id_producto,
    this.id_usuario,
    this.cantidad,
    this.total,
    this.imagen,

  });

  int? id;
  int? id_producto;
  int? id_usuario;
  int? cantidad;
  double? total;
  String? imagen;

  factory DataCarrito.fromJson(String str) => DataCarrito.fromMap(json.decode(str));

   String toJson() => json.encode(toMap());

  factory DataCarrito.fromMap(Map<String, dynamic> json) => DataCarrito(
        id: json["_id"],
        id_producto: json["id_producto"],
        id_usuario: json["id_usuario"],
        cantidad: json["cantidad"],
        total: json["total"],
        imagen: json["imagen"],
    );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "id_producto": id_producto,
        "id_usuario": id_usuario,
        "cantidad": cantidad,
        "total": total,
        "imagen": imagen,
    };

}