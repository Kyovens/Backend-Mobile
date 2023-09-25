import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Minggu02(title: 'Flutter Demo Home Page'),
    );
  }
}

class Minggu02 extends StatefulWidget {
  const Minggu02({super.key, required this.title});

  final String title;

  @override
  State<Minggu02> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Minggu02> {
  @override
  void initState() {
    super.initState();
    LostData();
  }

  void loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = (prefs.getDouble(_keyScore) ?? 0);
      _image = prefs.getString(_keyImage);
    });
  }

  String? _image;
  double _score = 0;
  final ImagePicker _picker = ImagePicker();
  final String _keyScore = 'score';
  final String _keyImage = 'image';
  late SharedPreferences prefs;
  final StreamController <bool> _loadController = StreamController<bool>();

  void loadingScreen () async{
    _loadController.add(true);
    await Future.delayed(const Duration(seconds: 5),() {
      _loadController.add(false);
    });
  }
  // late StreamSubscription _sub;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(color: Colors.red[200]),
              child: StreamBuilder<bool>(
                stream: _loadController.stream,
                builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CircularProgressIndicator();
                }
              } else {
                  return _image != null
                  ? Image.file(
                      File(_image!),
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.fitHeight,
                    ): Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 198, 198, 198)),
                      width: 200,
                      height: 200,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
              },
              //
                  
            ,),)
            // StreamBuilder(builder: (context, snapshot) {
            //   if (!snapshot.hasData) {
            //     return Padding(padding: EdgeInsets.all(8.0),child: LinearProgressIndicator(),);
            //   } else if (snapshot.data != null) {

            //   }
            // }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery, imageQuality: 90);
                  setState(() {
                    _setImage(image?.path);
                  });
                },
                child: const Text("Take Image"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SpinBox(
                max: 10.0,
                min: 0.0,
                value: _score,
                decimals: 1,
                step: 0.1,
                decoration: const InputDecoration(labelText: 'Decimals'),
                onChanged: _setScore,
              ),
            ),
          ],
        )),
      ),
    );
  }

  Future<void> _setScore(double value) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble(_keyScore, value);
      _score = ((prefs.getDouble(_keyScore) ?? 0));
    });
  }

  Future<void> _setImage(String? value) async {
    prefs = await SharedPreferences.getInstance();
    if (value != null) {
      setState(() {
        prefs.setString(_keyImage, value);
        _image = prefs.getString(_keyImage);
      });
    }
  }
}
