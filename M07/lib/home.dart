import 'package:flutter/material.dart';
import 'package:m06/analisis.dart';

class MyHome extends StatefulWidget {
  final String wid;
  MyHome({super.key, required this.wid});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.logout_sharp,
            ),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("welcome $email"), Text("ID ${widget.wid}")],
        ),
      ),
    );
  }
}
