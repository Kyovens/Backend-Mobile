import 'package:flutter/material.dart';
import 'package:m10/contact.dart';
import 'package:m10/photo_screen.dart'; // Import your PhotoScreen file
import 'package:permission_handler/permission_handler.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int noButtonCount = 0;

  void contact() async {
    if (await Permission.contacts.status.isGranted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactScreen()));
    } else {
      if (noButtonCount < 3) {
        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Permission Required"),
            content: Text("Do you want to grant contacts permission?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  requestContactsPermission();
                },
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  handleNoButton();
                },
                child: Text("No"),
              ),
            ],
          ),
        );
      } else {
        // Show dialog and prompt user to go to settings
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Permission Required"),
            content: Text("To use this feature, you need to grant contacts permission. Go to settings?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No"),
              ),
            ],
          ),
        );
      }
    }
  }

  void requestContactsPermission() async {
    var status = await Permission.contacts.request();
    print(status);
    if (status == PermissionStatus.granted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactScreen()));
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  void handleNoButton() {
    setState(() {
      noButtonCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => contact(), child: Text("Contact")),
            ElevatedButton(onPressed: () => photos(), child: Text("Photos")),
          ],
        ),
      ),
    );
  }
}
