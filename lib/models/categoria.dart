import 'dart:convert';

class DataCategoria {
  DataCategoria({
    this.id,
    this.nombre

  });

  int? id;
  String? nombre;

  factory DataCategoria.fromJson(String str) => DataCategoria.fromMap(json.decode(str));

   String toJson() => json.encode(toMap());

  factory DataCategoria.fromMap(Map<String, dynamic> json) => DataCategoria(
        id: json["_id"],
        nombre: json["nombre"]
    );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
    };

}