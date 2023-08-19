// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class DataProdPed {
  DataProdPed({
    this.id,
    this.id_producto,
    this.id_pedido,
    this.cantidad,
    this.total,
    this.imagen,
  });

  int? id;
  int? id_producto;
  int? id_pedido;
  int? cantidad;
  int? total;
  String? imagen;

  factory DataProdPed.fromJson(String str) => DataProdPed.fromMap(json.decode(str));

   String toJson() => json.encode(toMap());

  factory DataProdPed.fromMap(Map<String, dynamic> json) => DataProdPed(
        id: json["_id"],
        id_producto: json["id_producto"],
        id_pedido: json["id_pedido"],
        cantidad: json["cantidad"],
        total: json["total"],
        imagen: json["imagen"],
    );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "id_producto": id_producto,
        "id_pedido": id_pedido,
        "cantidad": cantidad,
        "total": total,
        "imagen": imagen,
    };

}