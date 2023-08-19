
import 'dart:convert';

class DataRol {
  DataRol({
    this.id,
    this.nombre,
    this.descripcion,
  });

  int? id;
  String? nombre;
  String? descripcion;

  factory DataRol.fromJson(String str) => DataRol.fromMap(json.decode(str));

   String toJson() => json.encode(toMap());

  factory DataRol.fromMap(Map<String, dynamic> json) => DataRol(
        id: json["_id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
    );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
        "descripcion": descripcion,
    };

}