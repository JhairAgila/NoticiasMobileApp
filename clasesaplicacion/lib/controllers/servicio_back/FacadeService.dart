import 'dart:convert';

import 'package:clasesaplicacion/controllers/Conextion.dart';
import 'package:clasesaplicacion/controllers/servicio_back/RespuestaGenerica.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/InicioSesionSW.dart';
import 'package:http/http.dart' as http;

class FacadeService {
  Conexion c = Conexion();
  Future<InicioSesionSW> inicioSesion(Map<String, String> mapa) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};

    final String _url = c.URL + "admin/login";
    // final String _saveUser =  c.URL + "/admin/persona/save";
    final uri = Uri.parse(_url);
    InicioSesionSW isw = InicioSesionSW();
    try {
      final response =
          await http.post(uri, headers: _header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        if (response.statusCode == 404) {
          isw.code = 404;
          isw.tag = "Recurso no encontrado";
          isw.msg = "Error";
          isw.datos = {};
          return isw;
        } else {
          isw.code = mapa["code"];
          isw.tag = mapa["tag"];
          isw.msg = mapa["msg"];
          isw.datos = {};
          return isw;
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isw.code = mapa['code'];
        isw.tag = mapa['tag'];
        isw.msg = mapa['msg'];
        isw.datos = mapa['datos'];
        return isw;
      }
      // return RespuestaGenerica();
    } catch (e) {
      isw.code = 500;
      isw.tag = "Error inesperado";
      isw.msg = "Error";
      isw.datos = {};
      return isw;
    }
  }

  Future<RespuestaGenerica> listarNoticias() async {
    return await c.solicitudGet('noticiasActivas', true);
  }

  Future<RespuestaGenerica> listarNoticia(external, pagina) async {
    return await c.solicitudGet(
        'noticias/get/${external}?page=${pagina}', true);
  }

  Future<RespuestaGenerica> listarPersonas() async {
    return await c.solicitudGet('admin/personas', true);
  }

  Future<RespuestaGenerica> listarComentarios() async {
    return await c.solicitudGet('comentario/getAll', true);
  }

  Future<RespuestaGenerica> getPersona(external) async {
    return await c.solicitudGet('admin/persona/get/${external}', true);
  }

  Future<RespuestaGenerica> saveUser(user) async {
    return await c.solicitudPost('admin/persona/saveUser', true, user);
  }

  Future<RespuestaGenerica> editStateUser(user, external) async {
    return await c.solicitudPost(
        'admin/bandearUsuario/${external}', true, user);
  }

  Future<RespuestaGenerica> editUser(user, external) async {
    return await c.solicitudPost(
        'admin/persona/actualizar/${external}', true, user);
  }

  Future<RespuestaGenerica> saveComment(comment) async {
    return await c.solicitudPost('comentario', true, comment);
  }

  Future<RespuestaGenerica> editComment(comment, external) async {
    return await c.solicitudPut(
        'comentario/actualizar/${external}', true, comment);
  }

  Future<RespuestaGenerica> saveNoticia(noticia) async {
    return await c.solicitudPost('admin/noticias/save', true, noticia);
  }
}
