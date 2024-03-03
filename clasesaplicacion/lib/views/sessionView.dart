import 'dart:developer';

import 'package:clasesaplicacion/controllers/Conextion.dart';
import 'package:clasesaplicacion/controllers/servicio_back/FacadeService.dart';
import 'package:clasesaplicacion/controllers/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class SessionView extends StatefulWidget {
  const SessionView({Key? key}) : super(key: key);

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  void _iniciar() {
    setState(() {
      FacadeService servicio = FacadeService();
      Conexion c = Conexion();
      // c.solicitudGet("noticias", false);
      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "correo": correoControl.text,
          "clave": claveControl.text,
        };
        servicio.inicioSesion(mapa).then((value) async {
          if (value.code == 200) {
            // log(value.datos.toString());
            Utils util = Utils();
            util.saveValue('news-token', value.datos['token']);
            util.saveValue('user', value.datos['user']);
            util.saveValue('external', value.datos['id']);
            // util.saveValue('external', value.datos['token']);
            final SnackBar msg = SnackBar(
              content: Text('Bienvenido ${value.datos['user']}'),
            );
            if (value.datos['rol'] == 'PERSONA') {
              Navigator.pushNamed(context, '/noticias');
            }
            if (value.datos['rol'] == 'EDITOR') {
              Navigator.pushNamed(context, '/noticiasEditor');
            }
            if (value.datos['rol'] == 'ADMINISTRADOR') {
              Navigator.pushNamed(context, '/administracion');
            }

            ScaffoldMessenger.of(context).showSnackBar(msg);
          } else {
            // log(value.msg);
            final SnackBar msg = SnackBar(
              content: Text(value.tag),
            );
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }
        });
      } else {
        log('Error de llave');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 20),
                child: const Text('Noticias',
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 30))),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text('La mejor noticia',
                    style: TextStyle(fontSize: 20))),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text('Inicio de sesion',
                    style: TextStyle(fontSize: 20))),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Correo',
                    suffixIcon: Icon(Icons.alternate_email)),
                controller: correoControl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Debe ingresar correo';
                  }
                  if (!isEmail(value)) {
                    return 'Debe ingresar un correo valido';
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Clave', suffixIcon: Icon(Icons.key)),
                controller: claveControl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Debe ingresar clave';
                  }
                },
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Inicio'),
                onPressed: _iniciar,
              ),
            ),
            Row(
              children: <Widget>[
                const Text("Quieres crear una cuenta?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text("Crear cuenta",
                        style: TextStyle(fontSize: 14))),
              ],
            ),
            // Row(
            //   children: <Widget>[
            //     const Text('Ver noticias'),
            //     TextButton(
            //         onPressed: () {
            //           Navigator.pushNamed(context, '/noticias');
            //         },
            //         child: const Text("Ver noticias",
            //             style: TextStyle(fontSize: 14)))
            //   ],
            // ),
            // Row(
            //   children: <Widget>[
            //     const Text('Ver mapa2'),
            //     TextButton(
            //         onPressed: () {
            //           Navigator.pushNamed(context, '/map2');
            //         },
            //         child:
            //             const Text("Ver mapa2", style: TextStyle(fontSize: 14)))
            //   ],
            // ),
            // Row(
            //   children: <Widget>[
            //     const Text('Geolocator'),
            //     TextButton(
            //         onPressed: () {
            //           Navigator.pushNamed(context, '/geolocator');
            //         },
            //         child: const Text("Geolocator",
            //             style: TextStyle(fontSize: 14)))
            //   ],
            // )
            // Row(
            //   children: <Widget>[
            //     const Text('Geolocator'),
            //     TextButton(
            //         onPressed: () {
            //           Navigator.pushNamed(context, '/geolocator');
            //         },
            //         child: const Text("Geolocator",
            //             style: TextStyle(fontSize: 14)))
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
