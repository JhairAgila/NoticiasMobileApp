import 'package:clasesaplicacion/controllers/servicio_back/FacadeService.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Persona.dart';
import 'package:flutter/material.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  List<Persona> personaList = [];

  Future<List<Persona>> listarPersona() async {
    List<Persona> personaList = [];
    FacadeService servicio = FacadeService();

    var res = await servicio.listarPersonas();

    res.datos.forEach((item) {
      Persona newPersona = Persona(
        nombres: item['nombres'],
        apellidos: item['apellidos'],
        direccion: item['direccion'],
        estado: item["cuenta"]['estado'],
        id: item['id'],
      );
      personaList.add(newPersona);
    });
    return personaList;
  }

  void cambiarEstado(estado, external) {
    List<Persona> personaList = [];
    FacadeService servicio = FacadeService();
    Map<String, bool> mapa = {"estado": estado};
    servicio.editStateUser(mapa, external);
  }

  @override
  void initState() {
    // TODO: implement initState
    listarPersona().then((result) {
      setState(() {
        personaList = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return DataTable(
      sortColumnIndex: 0,
      sortAscending: true,
      columns: <DataColumn>[
        DataColumn(label: Text("Nombre"), tooltip: ('Nombre')),
        DataColumn(label: Text('Estado'), tooltip: 'Estado'),
        DataColumn(label: Text('Estado'), tooltip: 'Cambiar estado')
      ],
      rows: personaList.map<DataRow>((Persona personaItem) {
        return DataRow(
          cells: <DataCell>[
            DataCell(FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(personaItem.nombres + " " + personaItem.apellidos),
            )),
            DataCell(Text(personaItem.estado!
                ? 'Activo'
                : 'Desactivado' ?? 'Estado no establecido')),
            DataCell(
              Switch(
                value: personaItem.estado ?? false,
                onChanged: (newValue) {
                  setState(() {
                    cambiarEstado(newValue, personaItem.id);
                    personaItem.estado = newValue;
                  });
                },
              ),
            )
          ],
        );
      }).toList(),
    );
  }
}
