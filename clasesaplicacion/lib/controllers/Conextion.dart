import 'dart:convert';
import 'dart:developer';

import 'package:clasesaplicacion/controllers/servicio_back/RespuestaGenerica.dart';
import 'package:clasesaplicacion/controllers/utils/Utils.dart';
import 'package:http/http.dart' as http;

class Conexion {
  // final String URL = "http://localhost:3001/api/";
  final String URL = "http://192.168.100.16:3001/api/";
  final String URL_MEDIA =
      "http://localhost:3001/multimedia/"; //Tener cuidado con estas rutas
  static bool NO_TOKEN = false;

  Future<RespuestaGenerica> solicitudGet(String recurso, bool token) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    Utils util = Utils();
    //Prueba
    if (token) {
      // Utils util = Utils();
      String? tokenA = await util.getValue('news-token');
      print(tokenA.toString());
      _header = {
        'Content-Type': 'application/json',
        'news-token': tokenA.toString()
      };
    }
    final String _url = URL + recurso;
    final uri = Uri.parse(_url);
    try {
      final response = await http.get(uri, headers: _header);
      // log(response.statusCode);
      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          return _response(404, "Recurso no encontrad0", []);
        } else {
          return _response(500, "Error", []);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        //print(mapa);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      return _response(500, "Error", []);
    }
  }

  Future<RespuestaGenerica> solicitudPost(
      String recurso, bool token, Map<dynamic, dynamic> mapa) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    Utils util = Utils();
    if (token) {
      // Utils util = Utils();
      String? tokenA = await util.getValue('news-token');
      _header = {
        'Content-Type': 'application/json',
        'news-token': tokenA.toString()
      };
    }
    final String _url = URL + recurso;
    final uri = Uri.parse(_url);
    try {
      final response =
          await http.post(uri, headers: _header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          return _response(500, "Error", []);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      return _response(500, "Error", []);
    }
  }

  Future<RespuestaGenerica> solicitudPut(
      String recurso, bool token, Map<dynamic, dynamic> mapa) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    Utils util = Utils();
    if (token) {
      // Utils util = Utils();
      String? tokenA = await util.getValue('news-token');
      _header = {
        'Content-Type': 'application/json',
        'news-token': tokenA.toString()
      };
    }
    final String _url = URL + recurso;
    final uri = Uri.parse(_url);
    log(mapa.toString());
    try {
      final response =
          await http.put(uri, headers: _header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "No se pudo editar", []);
        } else {
          return _response(500, "Error", []);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      return _response(500, "Error", []);
    }
  }

  RespuestaGenerica _response(int code, String msg, dynamic data) {
    var respuesta = RespuestaGenerica();
    respuesta.code = code;
    respuesta.datos = data;
    respuesta.msg = msg;
    return respuesta;
  }
}
