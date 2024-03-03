import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';

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

class GeolocatorView extends StatefulWidget {
  const GeolocatorView({super.key});
  @override
  State<GeolocatorView> createState() => _Geolocator();
}

class _Geolocator extends State<GeolocatorView> {
  Future<Position> determinatePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Error");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinatePosition();
    print(position.latitude);
    print(position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geolocator"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          getCurrentLocation();
        },
        child: Text("Encontrar ruta"),
      )),
    );
  }
}
