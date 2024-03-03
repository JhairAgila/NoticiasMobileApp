import 'package:clasesaplicacion/controllers/servicio_back/FacadeService.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Comentario.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Noticia.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Persona.dart';
import 'package:clasesaplicacion/controllers/utils/Utils.dart';
import 'package:clasesaplicacion/views/MapOneNotice.dart';
import 'package:clasesaplicacion/views/addNoticiaView.dart';
import 'package:clasesaplicacion/views/commentViewAdmin.dart';
import 'package:clasesaplicacion/views/usersView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdministracionView extends StatefulWidget {
  const AdministracionView({Key? key}) : super(key: key);

  @override
  _AdministracionViewState createState() => _AdministracionViewState();
}

class _AdministracionViewState extends State<AdministracionView> {
  // Llamar a la función para cargar datos al iniciar la página
  Future<List<Noticia>>? _listadoNoticias;
  List<Comentario> _listComentarios = [];

  Future<List<Comentario>> cargarComentarios() async {
    List<Comentario> comentarios = [];
    FacadeService servicio = FacadeService();

    var res = await servicio.listarComentarios();
    res.datos.forEach((item) {
      Persona persona = Persona(
          nombres: item['persona']['nombres'],
          apellidos: item['persona']['apellidos']);
      Comentario newComment = Comentario(
          cuerpo: item['cuerpo'],
          estado: item['estado'],
          longitud: item['longitud'],
          latitud: item['latitud'],
          persona: persona);
      comentarios.add(newComment);
    });
    return comentarios;
  }

  Future<List<Noticia>> cargarDatos() async {
    List<Noticia> noticias = [];
    FacadeService servicio = FacadeService();

    var res =
        await servicio.listarNoticias(); // Espera a que se resuelva la promesa
    res.datos['rows'].forEach((item) {
      List<Comentario> noticiaComentarios = [];
      Persona personaA = Persona(
        nombres: item['persona']['nombres'],
        apellidos: item['persona']['apellidos'],
      );

      item['pertenece_noticia'].forEach((comentario) {
        Persona personaComentario = Persona(
            nombres: comentario['persona']['nombres'],
            apellidos: comentario['persona']['apellidos'],
            id: comentario['persona']['external_id']);
        DateTime parsedDate = DateTime.parse(comentario['updatedAt']);

        // Format the DateTime object into the desired format
        String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

        print(formattedDate); // Output: 2024-02-17
        Comentario newComentario = Comentario(
            id: comentario['external_id'],
            cuerpo: comentario['cuerpo'],
            estado: comentario['estado'],
            longitud: comentario['longitud'],
            latitud: comentario['latitud'],
            persona: personaComentario,
            fecha: formattedDate);

        noticiaComentarios.add(newComentario);
      });

      noticias.add(Noticia(
        id: item['external_id'],
        titulo: item["titulo"],
        cuerpo: item["cuerpo"],
        persona: personaA,
        comentarios: noticiaComentarios,
        imagen: item["archivo"],
      ));
    });

    return noticias.isNotEmpty ? noticias : [];
  }

  @override
  void initState() {
    super.initState();
    cargarDatos().then((listado) {
      setState(() {
        _listadoNoticias = Future.value(listado);
      });
    });
    cargarComentarios().then((listado) {
      setState(() {
        _listComentarios = listado;
        print(listado.toString());
      });
    });
  }

  Future<void> logout() async {
    Utils util = Utils();
    util.removeAllItem();
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.remove_red_eye_sharp),
              iconSize: 36,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new MapOneNotice(_listComentarios);
                }));
              },
            ),
            IconButton(
              icon: Icon(Icons.supervised_user_circle_outlined),
              iconSize: 36,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => UsersView()));
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              iconSize: 36,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddNoticiaView()));
              },
            ),
            IconButton(
              icon: Icon(Icons.logout_outlined),
              iconSize: 36,
              onPressed: () {
                logout();
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Noticia>?>(
          future: _listadoNoticias,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 1,
                children:
                    snapshot.data != null ? _listNoticias(snapshot.data!) : [],
              );
            } else if (snapshot.hasError) {
              return Text('Error');
            }
            return Center(
              child: CircularProgressIndicator(),
            );
            // child: Text('Cargando'),
          },
        ));
  }

  List<Widget> _listNoticias(List<Noticia> data) {
    List<Widget> noticias = [];
    for (var noticia in data) {
      noticias.add(Card(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              noticia.titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          Image.asset(
            "multimedia/${noticia.imagen}",
            width: 300,
            height: 300,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87, // Color para el texto "Autor"
                ),
                children: [
                  TextSpan(
                      text: 'Autor: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text:
                        '${noticia.persona.nombres} ${noticia.persona.apellidos}',
                    style: TextStyle(
                      color: Colors.black87, // Color para el nombre del autor
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              noticia.cuerpo,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              alignment: Alignment.center,
              height: 60,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new MapOneNotice(noticia.comentarios);
                    }));
                  },
                  child: const Text(
                    "Ver comentarios en mapa",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ))),
          Container(
              alignment: Alignment.center,
              height: 60,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new CommentViewAdmin(noticia);
                    }));
                  },
                  child: const Text(
                    "Ver noticia",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  )))
        ],
      )));
    }
    return noticias;
  }
}
