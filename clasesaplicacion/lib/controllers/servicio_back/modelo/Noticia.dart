import 'package:clasesaplicacion/controllers/servicio_back/modelo/Comentario.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Persona.dart';

class Noticia {
  String id;
  String titulo;
  String cuerpo;
  Persona persona;
  String imagen;
  List<Comentario> comentarios;
  Noticia(
      {required this.id,
      required this.titulo,
      required this.cuerpo,
      required this.persona,
      required this.imagen,
      required this.comentarios});
  Noticia.vacio()
      : id = '',
        titulo = '',
        cuerpo = '',
        persona = Persona.vacio(),
        imagen = '',
        comentarios = [];
}
