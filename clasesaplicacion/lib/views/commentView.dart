import 'package:clasesaplicacion/controllers/Conextion.dart';
import 'package:clasesaplicacion/controllers/servicio_back/FacadeService.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Comentario.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Noticia.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Persona.dart';
import 'package:clasesaplicacion/controllers/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class CommentView extends StatefulWidget {
  Noticia noticia = new Noticia.vacio();
  CommentView(this.noticia);

  // const CommentView({super.key});
  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  //Controler for input
  int _loadedComments = 1;
  ScrollController _scrollController = ScrollController();
  bool _loadingComments = false;
  String? external_id;
  List<Comentario> comentarios = [];
  final commentController = TextEditingController();
  TextEditingController textEditedControler = TextEditingController();
  Position? position;
  Future<Position> determinatePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Error");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentLocation() async {
    position = await determinatePosition();
    print(position!.latitude);
    print(position!.longitude);
  }

  Future<void> comentar() async {
    await getCurrentLocation();

    setState(() {
      FacadeService servicio = FacadeService();
      Conexion c = Conexion();
      // if (position.latitude != null) {}

      bool estadoUser = true;
      Map<String, dynamic> mapa = {
        "cuerpo": commentController.text,
        "longitud": position!.latitude.toString(),
        "latitud": position!.longitude.toString(),
        "noticia_id": widget.noticia.id,
        "id_persona": external_id!,
        "estado": estadoUser
      };
      print(mapa);
      servicio.saveComment(mapa).then((value) async {
        if (value.code == 200) {
          print('datos ' + value.datos["nombres"]);
          DateTime parsedDate = DateTime.parse(value.datos['updatedAt']);

          // Format the DateTime object into the desired format
          String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          Comentario comentario = Comentario(
            id: value.datos["idComentario"],
            cuerpo: commentController.text,
            estado: estadoUser,
            longitud: position!.latitude.toString(),
            latitud: position!.latitude.toString(),
            fecha: formattedDate,
            persona: Persona(
                nombres: value.datos["nombres"],
                apellidos: value.datos["apellidos"],
                id: value.datos["external_id"]),
          );
          setState(() {
            comentarios.insert(0, comentario);
          });

          final SnackBar msg = SnackBar(
            content: Text('Mensaje guardado'),
          );
          ScaffoldMessenger.of(context).showSnackBar(msg);
        } else {
          final SnackBar msg = SnackBar(
            content: Text('No se pudo guardar el mensaje'),
          );
          ScaffoldMessenger.of(context).showSnackBar(msg);
        }
      });
    });
  }

  @override
  void initState() {
    comentarios = widget.noticia.comentarios;
    _scrollController.addListener(_scrollListener);
    super.initState();
    Utils util = Utils();
    util.getValue('external').then((value) {
      setState(() {
        external_id = value;
      });
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    textEditedControler.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> editComment(comentarioId) async {
    await getCurrentLocation();
    Utils utils = Utils();
    setState(() {
      FacadeService servicio = FacadeService();
      Conexion c = Conexion();
      print(comentarioId.toString());
      Map<String, dynamic> mapa = {
        "cuerpo": textEditedControler.text,
        "estado": true,
        "usuario": external_id,
        "longitud": position!.longitude.toString(),
        "latitud": position!.latitude.toString(),
        "noticia_id": widget.noticia.id,
      };
      Comentario comentario =
          comentarios.firstWhere((c) => c.id == comentarioId);

      // Actualiza el texto del comentario
      comentario.cuerpo = textEditedControler.text;

      servicio.editComment(mapa, comentarioId).then((value) async {
        if (value.code == 200) {
          final SnackBar msg = SnackBar(
            content: Text('Comentario editado'),
          );
          // Navigator.pushNamed(context, '/noticias');
          ScaffoldMessenger.of(context).showSnackBar(msg);
        } else {
          final SnackBar msg = SnackBar(
            content: Text('No se pudo editar comentario'),
          );
          ScaffoldMessenger.of(context).showSnackBar(msg);
        }
      });
    });
  }

  //Load COments

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // El usuario ha llegado al final de la lista, carga más comentarios
      _loadMoreComments();
    }
  }

  void _loadMoreComments() async {
    _loadedComments++;
    if (!_loadingComments) {
      FacadeService servicio = FacadeService();
      print('id de noticia ' + widget.noticia.id);
      var res =
          await servicio.listarNoticia(widget.noticia.id, _loadedComments);
      setState(() {
        _loadingComments = true;
      });
      res.datos['rows'].forEach((item) {
        List<Comentario> noticiaComentarios = [];
        item['pertenece_noticia'].forEach((comentario) {
          Persona personaComentario = Persona(
              nombres: comentario['persona']['nombres'],
              apellidos: comentario['persona']['apellidos'],
              id: comentario["persona"]["external_id"]);
          DateTime parsedDate = DateTime.parse(comentario['updatedAt']);

          // Format the DateTime object into the desired format
          String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          Comentario newComentario = Comentario(
              id: comentario['external_id'],
              cuerpo: comentario['cuerpo'],
              estado: comentario['estado'],
              longitud: comentario['longitud'],
              latitud: comentario['latitud'],
              persona: personaComentario,
              fecha: formattedDate);
          noticiaComentarios.add(newComentario);
          comentarios.add(newComentario);
          print(newComentario.toString());
        });

        // comentarios = noticiaComentarios;
        print(comentarios.length);
      });
      // comentarios = res.datos["rows"][0]["pertenece_noticia"];
      // Marca que la carga ha finalizado
      setState(() {
        _loadingComments = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Comentar Noticia"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // padding: const EdgeInsets.all(10),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.noticia.titulo,
                style: TextStyle(
                    color: const Color.fromARGB(255, 143, 27, 18),
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Image.asset(
              "multimedia/${widget.noticia.imagen}",
              width: 150,
              height: 150,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.noticia.cuerpo,
                style: TextStyle(fontSize: 14),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              width: 600,
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Comenta...',
                ),
                maxLines: 2,
              ),
            ),
            Container(
              height: 40,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Comentar'),
                onPressed: comentar,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(
                "Comentarios",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: _listComments(widget.noticia.comentarios),
              ),
            ),
            if (_loadingComments) CircularProgressIndicator(),
          ],
        ));
  }

  // Return list of comments
  List<Widget> _listComments(List<Comentario> data) {
    List<Widget> comments = [];

    // String? external_id = await util.getValue('external');
    for (var comment in data) {
      // print(comment.cuerpo);
      if (external_id == comment.persona.id) {
        comments.add(
          InkWell(
            onTap: () {
              textEditedControler.text = comment.cuerpo;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Editar comentario'),
                    content: TextField(
                      decoration: InputDecoration(
                          labelText: 'Comentar',
                          suffixIcon: Icon(Icons.account_tree)),
                      // initialValue: comment.cuerpo,
                      controller: textEditedControler,
                      maxLines: 3,
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          editComment(comment.id);
                          Navigator.of(context).pop();
                        },
                        child: Text('Guardar'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[100], // Cambia el color de fondo aquí
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(comment.persona.nombres,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  SizedBox(height: 8.0),
                  ColoredBox(color: Colors.black26),
                  Text(comment.cuerpo),
                  Text("Fecha de publicacion: " + comment.fecha.toString()),
                ],
              ),
            ),
          ),
        );
      } else {
        comments.add(Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(comment.persona.nombres),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(comment.cuerpo),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text("Fecha de publicacion: " + comment.fecha.toString()),
              ),
            ],
          ),
        ));
      }
    }
    return comments;
  }
}
