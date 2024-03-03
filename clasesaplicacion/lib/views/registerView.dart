import 'package:clasesaplicacion/controllers/servicio_back/FacadeService.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nombresC = TextEditingController();
    final TextEditingController apellidosC = TextEditingController();
    final TextEditingController direccionC = TextEditingController();
    final TextEditingController celularC = TextEditingController();
    // final TextEditingController fecha_nacC =();
    final TextEditingController correoC = TextEditingController();
    final TextEditingController claveC = TextEditingController();

    void _registrar() {
      setState(() {
        FacadeService servicio = FacadeService();
        // Conexion conexion = Conexion();
        if (_formKey.currentState!.validate()) {
          Map<String, String> mapa = {
            "nombres": nombresC.text,
            "apellidos": apellidosC.text,
            "direccion": direccionC.text,
            "celular": celularC.text,
            "fecha_nac": "2000-12-12",
            "correo": correoC.text,
            "clave": claveC.text,
          };
          servicio.saveUser(mapa).then((res) async {
            if (res.code == 200) {
              final SnackBar msg = SnackBar(
                content: Text('Usuario  guardado'),
              );
              ScaffoldMessenger.of(context).showSnackBar(msg);
            } else {
              final SnackBar msg = SnackBar(
                content: Text('Error ${res.msg}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(msg);
            }
          });
        }
      });
    }

    return Form(
      key: _formKey,
      child: Scaffold(
          body: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text('La mejor noticia',
                  style: TextStyle(fontSize: 20))),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child:
                  const Text('Crear cuenta', style: TextStyle(fontSize: 20))),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Apellidos', suffixIcon: Icon(Icons.account_tree)),
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
                  labelText: 'Nombres', suffixIcon: Icon(Icons.account_tree)),
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
                  labelText: 'Direccion', suffixIcon: Icon(Icons.account_tree)),
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
                  labelText: 'Celular', suffixIcon: Icon(Icons.account_tree)),
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
                  labelText: 'Correo', suffixIcon: Icon(Icons.mail_rounded)),
              controller: correoC,
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
              child: const Text('Registrar'),
              onPressed: _registrar,
            ),
          ),
          //Problema con ROw
          Row(
            children: <Widget>[
              const Text("Ya tienes una cuenta"),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: const Text("Inicio de sesion",
                      style: TextStyle(fontSize: 20)))
            ],
          ),
        ],
      )),
    );
  }
}
