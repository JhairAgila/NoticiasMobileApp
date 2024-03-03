import 'package:clasesaplicacion/controllers/servicio_back/RespuestaGenerica.dart';

class InicioSesionSW extends RespuestaGenerica {
  String tag = '';
  InicioSesionSW({msg = '', code = 0, this.tag = ''});
}
