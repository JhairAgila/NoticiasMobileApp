import 'package:clasesaplicacion/controllers/Conextion.dart';
import 'package:clasesaplicacion/controllers/servicio_back/FacadeService.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Persona.dart';
import 'package:clasesaplicacion/controllers/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class EditProfileView extends StatefulWidget {
  Persona persona = new Persona.vacio();
  EditProfileView(this.persona);
  // const CommentView({super.key});
  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  //Controler for input
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombresC = TextEditingController();
  final TextEditingController apellidosC = TextEditingController();
  final TextEditingController direccionC = TextEditingController();
  final TextEditingController celularC = TextEditingController();
  final TextEditingController correoC = TextEditingController();
  final TextEditingController claveC = TextEditingController();

  @override
  void initState() {
    super.initState();
    nombresC.text = widget.persona.nombres;
    apellidosC.text = widget.persona.apellidos;
    direccionC.text = widget.persona.direccion!;
    celularC.text = widget.persona.celular!;
    correoC.text = widget.persona.correo!;
  }

  Future<void> editar() async {
    Utils util = Utils();
    String? external_id = await util.getValue('external');
    setState(() {
      FacadeService servicio = FacadeService();
      Conexion c = Conexion();

      // if (position.latitude != null) {}

      bool estadoUser = true;
      Map<String, dynamic> mapa = {
        "nombres": nombresC.text,
        "apellidos": apellidosC.text,
        "direccion": direccionC.text,
        "celular": celularC.text,
        "fecha_nac": "2000-12-12",
        "correo": correoC.text,
        "clave": claveC.text,
      };
      servicio.editUser(mapa, external_id).then((value) async {
        if (value.code == 200) {
          Persona p = Persona(
            nombres: nombresC.text,
            apellidos: apellidosC.text,
            direccion: direccionC.text,
            celular: celularC.text,
            fecha_nac: "2000-12-12",
            correo: correoC.text,
          );
          final SnackBar msg = SnackBar(
            content: Text('Perfil editado'),
          );
          // Navigator.pushNamed(context, '/noticias');
          ScaffoldMessenger.of(context).showSnackBar(msg);
          print(value.toString());
          // Llamar a Navigator.pop() después de mostrar el SnackBar
          Navigator.pop(context, p);
        } else {
          final SnackBar msg = SnackBar(
            content: Text('No se pudo editar perfil'),
          );
          ScaffoldMessenger.of(context).showSnackBar(msg);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Editar Perfil'),
          ),
          body: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text('Perfil', style: TextStyle(fontSize: 20))),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Comentario',
                      suffixIcon: Icon(Icons.account_tree)),
                  controller: apellidosC,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Debe ingresar apellidos';
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Nombres',
                      suffixIcon: Icon(Icons.account_tree)),
                  controller: nombresC,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Debe ingresar nombres';
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Direccion',
                      suffixIcon: Icon(Icons.account_tree)),
                  controller: direccionC,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Debe ingresar direccion';
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Celular',
                      suffixIcon: Icon(Icons.account_tree)),
                  controller: celularC,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Debe ingresar celular';
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Correo',
                      suffixIcon: Icon(Icons.mail_rounded)),
                  controller: correoC,
                  readOnly: true,
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
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Clave', suffixIcon: Icon(Icons.account_tree)),
                  controller: claveC,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Debe ingresar constrase;a';
                    }
                  },
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Guardar Cambios'),
                  onPressed: editar,
                ),
              ),
              //Problema con ROw
            ],
          )),
    );
  }
}
