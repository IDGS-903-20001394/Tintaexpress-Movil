
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
class DataProducto {
  DataProducto({
    this.id,
    this.nombre,
    this.precio,
    this.descripcion,
    this.imagen,
    this.estatus,
    this.materia_base,
    this.id_categoria,

  });

  int? id;
  String? nombre;
  double? precio;
  String? descripcion;
  String? imagen;
  int? estatus;
  int? materia_base;
  int? id_categoria;

  factory DataProducto.fromJson(String str) => DataProducto.fromMap(json.decode(str));

   String toJson() => json.encode(toMap());

  factory DataProducto.fromMap(Map<String, dynamic> json) => DataProducto(
        id: json["_id"],
        nombre: json["nombre"],
        precio: json["precio"],
        descripcion: json["descripcion"],
        imagen: json["imagen"],
        estatus: json["estatus"],
    );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
        "precio": precio,
        "descripcion": descripcion,
        "imagen": imagen,
        "estatus": estatus,
    };

}