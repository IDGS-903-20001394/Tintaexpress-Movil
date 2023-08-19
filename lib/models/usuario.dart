
import 'dart:convert';

class DataUsuario {
  DataUsuario({
    this.id,
    this.nombre,
    this.email,
    this.password,
    this.telefono,
    this.direccion,
    this.rol
  });

  int? id;
  String? nombre;
  String? email;
  String? password;
  String? telefono;
  String? direccion;
  int? rol;

  factory DataUsuario.fromJson(String str) => DataUsuario.fromMap(json.decode(str));

   String toJson() => json.encode(toMap());

  factory DataUsuario.fromMap(Map<String, dynamic> json) => DataUsuario(
        id: json["_id"],
        nombre: json["nombre"],
        email: json["email"],
        password: json["password"],
        telefono: json["telefono"],
        direccion: json["direccion"],
        rol: json["rol"],
    );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
        "email": email,
        "password": password,
        "telefono": telefono,
        "direccion": direccion,
        "rol": rol,
    };

}