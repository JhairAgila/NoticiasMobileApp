import 'package:clasesaplicacion/controllers/servicio_back/FacadeService.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Persona.dart';
import 'package:clasesaplicacion/controllers/utils/Utils.dart';
import 'package:clasesaplicacion/views/EditProfile.dart';
import 'package:flutter/material.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({Key? key}) : super(key: key);

  @override
  _PerfilViewState createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  // Llamar a la función para cargar datos al iniciar la página
  Future<Persona>? persona;
  final _formKey = GlobalKey<FormState>();

  Future<Persona> cargarDatos() async {
    Utils util = Utils();
    String? external_id = await util.getValue('external');
    FacadeService servicio = FacadeService();

    var res = await servicio
        .getPersona(external_id!); // Espera a que se resuelva la promesa

    print(res.datos.toString());

    Persona persona = Persona(
        nombres: res.datos['nombres'],
        apellidos: res.datos['apellidos'],
        direccion: res.datos['direccion'],
        celular: res.datos['celular'],
        fecha_nac: res.datos['fecha_nac'],
        correo: res.datos['cuenta']['correo']);
    return persona;
    // return noticias;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Perfil'),
        ),
        body: FutureBuilder<Persona>(
          future: persona,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return listarPerfil(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('Error');
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Widget listarPerfil(Persona data) {
    return Form(
      key: _formKey,
      child: Scaffold(
          body: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text('Informacion del usuario',
                  style: TextStyle(fontSize: 20))),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child:
                        Text('Apellidos: '), // Texto a la izquierda del input
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Borde alrededor del input
                    ),
                    readOnly: true, // Hacer el campo de solo lectura
                    controller: TextEditingController(
                        text: data
                            .apellidos), // Asignar el valor de los apellidos al campo
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Debe ingresar apellidos';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('Nombres: '), // Texto a la izquierda del input
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Borde alrededor del input
                    ),
                    readOnly: true, // Hacer el campo de solo lectura
                    controller: TextEditingController(
                        text: data
                            .nombres), // Asignar el valor de los apellidos al campo
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'No tiene nombres registrados';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child:
                        Text('Direccion: '), // Texto a la izquierda del input
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Borde alrededor del input
                    ),
                    readOnly: true, // Hacer el campo de solo lectura
                    controller: TextEditingController(
                        text: data
                            .direccion), // Asignar el valor de los apellidos al campo
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Debe ingresar direccion';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('Celular: '), // Texto a la izquierda del input
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Borde alrededor del input
                    ),
                    readOnly: true, // Hacer el campo de solo lectura
                    controller: TextEditingController(
                        text: data
                            .celular), // Asignar el valor de los apellidos al campo
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Debe ingresar celular';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                        'Fecha nacimiento: '), // Texto a la izquierda del input
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Borde alrededor del input
                    ),
                    readOnly: true, // Hacer el campo de solo lectura
                    controller: TextEditingController(
                        text: data
                            .fecha_nac), // Asignar el valor de los apellidos al campo
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Debe ingresar direccion';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('Cuenta: '), // Texto a la izquierda del input
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Borde alrededor del input
                    ),
                    readOnly: true, // Hacer el campo de solo lectura
                    controller: TextEditingController(
                        text: data
                            .correo), // Asignar el valor de los apellidos al campo
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Debe ingresar correo';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.center,
              height: 60,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () async {
                    final updatedData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileView(data)),
                    );
                    if (updatedData != null) {
                      setState(() {
                        persona = Future.value(updatedData);
                      });
                    }
                  },
                  child: const Text(
                    "Editar",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ))),
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    cargarDatos().then((result) {
      setState(() {
        persona = Future.value(result);
      });
    });
  }
}
