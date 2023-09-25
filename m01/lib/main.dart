import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(const MyApp());
  // getData();
  // print('Gettng user data');
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
      home: const ContohStream(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _data = [];
// var data = [];
  Future<List<String>> getData() async {
    var data = ['Bunny', 'Funny', 'Miles'];
    await Future.delayed(const Duration(seconds: 3), () {
      print("download ${data.length} data");
    });
    return data;
  }

  void getUserData() async {
    var result = await getData();
    setState(() {
      _data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Daftar Pengguna',
            ),
            Text(
              '$_data',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
                onPressed: () {
                  getUserData();
                },
                child: Text('Get User'))
          ],
        ),
      ),
    );
  }
}

class ContohStream extends StatefulWidget {
  const ContohStream({super.key});

  @override
  State<ContohStream> createState() => _ContohStreamState();
}

class _ContohStreamState extends State<ContohStream> {
  int percent = 100;
  int getStream = 0;
  double circular = 1;
  late StreamSubscription _sub;
  final Stream _myStream =
      Stream.periodic(const Duration(seconds: 1), (int count) {
    return count;
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stream")),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // final double avaWidth = constraints.maxWidth;
            final double avaHeight = constraints.maxHeight;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: CircularPercentIndicator(
                  radius: avaHeight / 5,
                  lineWidth: 10,
                  percent: circular,
                  center: Text("$percent %"),
                ))
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _sub = _myStream.listen((event) {
          getStream = int.parse(event.toString());
          setState(() {
            if (percent - getStream <= 0) {
              _sub.cancel();
              percent = 0;
              circular = 0;
            } else {
              percent = percent - getStream;
              circular = percent / 100;
            }
          });
        });
      }),
    );
  }
}
