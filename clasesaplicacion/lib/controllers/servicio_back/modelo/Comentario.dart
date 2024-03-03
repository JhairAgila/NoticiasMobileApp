import 'package:clasesaplicacion/controllers/servicio_back/modelo/Persona.dart';

class Comentario {
  String? id;
  String? fecha;
  String cuerpo;
  bool estado;
  String longitud;
  String latitud;
  Persona persona;
  Comentario(
      {this.id,
      this.fecha,
      required this.cuerpo,
      required this.estado,
      required this.longitud,
      required this.latitud,
      required this.persona});
  factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
        cuerpo: json["cuerpo"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        estado: json["estado"],
        persona: Persona.fromJson(json["persona"]),
      );

  Map<String, dynamic> toJson() => {
        "cuerpo": cuerpo,
        "latitud": latitud,
        "longitud": longitud,
        "estado": estado,
        "persona": persona.toJson(),
      };
  Comentario.vacio()
      : cuerpo = '',
        estado = false,
        longitud = '',
        latitud = '',
        persona = Persona.vacio();
}
