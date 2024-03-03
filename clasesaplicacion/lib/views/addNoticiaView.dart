import 'package:clasesaplicacion/controllers/servicio_back/FacadeService.dart';
import 'package:clasesaplicacion/controllers/utils/Utils.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class AddNoticiaView extends StatefulWidget {
  const AddNoticiaView({Key? key}) : super(key: key);
  @override
  _AddNoticiaViewState createState() => _AddNoticiaViewState();
}

class _AddNoticiaViewState extends State<AddNoticiaView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tituloC = TextEditingController();
  final TextEditingController cuerpoC = TextEditingController();
  final TextEditingController fechaC = TextEditingController();
  String? selectedTipoNoticia;
  final TextEditingController archivoC = TextEditingController();
  DateTime? fecha;
  final List<String> opcionesTipoNoticia = [
    'NORMAL',
    'FLASH',
    'DEPORTIVA',
    'POLITICA',
    'CULTURAL',
    'CIENTIFICA'
  ];

  void saveNoticia() async {
    Utils util = Utils();
    String? external_id = await util.getValue('external');
    FacadeService servicio = FacadeService();
    String formatDate(DateTime dateTime) {
      return '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }

    String fechaFormateada = formatDate(fecha!);
    print(fechaFormateada);
    if (_formKey.currentState!.validate()) {
      Map<String, String> mapa = {
        "titulo": tituloC.text,
        "cuerpo": cuerpoC.text,
        "fecha": fechaFormateada,
        "tipo_noticia": selectedTipoNoticia!,
        "archivo": archivoC.text,
        "persona": external_id!
      };
      print(mapa);
      servicio.saveNoticia(mapa).then((res) async {
        if (res.code == 200) {
          final SnackBar msg = SnackBar(
            content: Text('Noticia guardada'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Agregar Noticia'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Nueva noticia',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Titulo',
                  suffixIcon: Icon(Icons.account_tree),
                ),
                controller: tituloC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Debe ingresar el titulo';
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Cuerpo',
                  suffixIcon: Icon(Icons.account_tree),
                ),
                controller: cuerpoC,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter Date',
                ),
                firstDate: DateTime.now().add(const Duration(days: 10)),
                lastDate: DateTime.now().add(const Duration(days: 40)),
                initialPickerDateTime:
                    DateTime.now().add(const Duration(days: 20)),
                onChanged: (DateTime? value) {
                  fecha = value;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tipo de noticia',
                  suffixIcon: Icon(Icons.account_tree),
                ),
                value: selectedTipoNoticia,
                items: opcionesTipoNoticia.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTipoNoticia = newValue;
                    print(selectedTipoNoticia);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Debe seleccionar un tipo de noticia';
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Archivo',
                  suffixIcon: Icon(Icons.account_tree),
                ),
                controller: archivoC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Debe ingresar un archivo';
                  }
                },
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () {
                  saveNoticia();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
