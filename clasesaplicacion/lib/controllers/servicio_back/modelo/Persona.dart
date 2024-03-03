class Persona {
  String nombres;
  String apellidos;
  String? direccion;
  String? celular;
  String? fecha_nac;
  String? correo;
  String? id;
  bool? estado;
  Persona(
      {required this.nombres,
      required this.apellidos,
      this.direccion,
      this.celular,
      this.fecha_nac,
      this.correo,
      this.id,
      this.estado});

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
        apellidos: json["apellidos"],
        nombres: json["nombres"],
      );

  Map<String, dynamic> toJson() => {
        "apellidos": apellidos,
        "nombres": nombres,
      };
  Persona.vacio()
      : nombres = '',
        apellidos = '';
  // id = '';
}
