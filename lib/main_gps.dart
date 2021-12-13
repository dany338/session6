import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const LocScreen(),
    );
  }
}

class LocScreen extends StatefulWidget {
  const LocScreen({Key? key}) : super(key: key);

  @override
  State<LocScreen> createState() => _LocScreenState();
}

class _LocScreenState extends State<LocScreen> {
  String? location;

  @override
  void dispose() {
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service is not enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is not granted');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uso de geolocalización'),
        backgroundColor: Colors.blueGrey.shade400,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(location ?? 'No hay ubicación'),
            ElevatedButton(
              child: const Text('Abrir mapa'),
              onPressed: () async {
                Position position = await _determinePosition();
                MapsLauncher.launchCoordinates(
                  position.latitude,
                  position.longitude,
                );
              },
            ),
            ElevatedButton(
              child: const Text('Obtener ubicación'),
              onPressed: () async {
                Position position = await _determinePosition();
                setState(() {
                  location =
                      'Latitud: ${position.latitude}\nLongitud: ${position.longitude}';
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
