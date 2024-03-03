import 'package:clasesaplicacion/controllers/servicio_back/modelo/Comentario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const Geolocaotortateless2());
}

class Geolocaotortateless2 extends StatelessWidget {
  const Geolocaotortateless2({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Noticia noticia = new Noticia.vacio();

    return Scaffold(
      appBar: AppBar(
        title: Text("Map Wiew 2"),
      ),
      body: Text("Map view 2 Staful"),
    );
  }
}

class MapOneNotice extends StatefulWidget {
  List<Comentario> comentarios = [];
  MapOneNotice(this.comentarios);
  @override
  State<MapOneNotice> createState() => _Geolocator();
}

class _Geolocator extends State<MapOneNotice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("View map"),
        ),
        body: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(-3.9931, -79.2047),
            initialZoom: 9.2,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
            MarkerLayer(markers: _listMarkets(widget.comentarios)),
          ],
        ));
  }

  List<Marker> _listMarkets(List<Comentario> comentarios) {
    List<Marker> markets = [];

    for (var comment in comentarios) {
      print(comment.latitud.toString());
      print(comment.longitud.toString());
      markets.add(Marker(
          point: LatLng(
              double.parse(comment.longitud), double.parse(comment.latitud)),
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(comment.persona.nombres +
                      " " +
                      comment.persona.apellidos),
                  duration: Duration(seconds: 2), // Duración del mensaje
                ),
              );
            },
            child: Icon(Icons.location_pin, size: 30, color: Colors.black),
          )));
    }
    // print(markets.length);
    return markets;
  }
}
