import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const CamScreen(),
    );
  }
}

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  File? image;

  @override
  void dispose() {
    super.dispose();
  }

  _openGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedFile!.path);
      log('image!.path: ${image!.path}');
      log('base64Encode: ${base64Encode(image!.readAsBytesSync())}');
    });
    Navigator.of(context).pop();
  }

  _openCamera() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    setState(() {
      image = File(pickedFile!.path);
      log('image!.path: ${image!.path}');
      log('base64Encode: ${base64Encode(image!.readAsBytesSync())}');
    });
    Navigator.of(context).pop();
  }

  Future _showSelectDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona una opción'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Row(
                    children: const [
                      Text('Galería'),
                      Padding(padding: EdgeInsets.all(8.0)),
                      Icon(Icons.photo_library),
                    ],
                  ),
                  onTap: () {
                    _openGallery();
                  },
                ),
                const Padding(padding: EdgeInsets.all(16.0)),
                GestureDetector(
                  child: Row(
                    children: const [
                      Text('Cámara'),
                      Padding(padding: EdgeInsets.all(8.0)),
                      Icon(Icons.camera_alt),
                    ],
                  ),
                  onTap: () {
                    _openCamera();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uso de galería y camara'),
        backgroundColor: Colors.blueGrey.shade400,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          image != null
              ? Image.file(image!, width: 400.0, height: 400.0)
              : const Center(
                  child: Text('Sin imagen'),
                ),
          ElevatedButton(
            child: const Text('Galería'),
            onPressed: () async {
              await _showSelectDialog();
            },
          ),
        ],
      ),
    );
  }
}
