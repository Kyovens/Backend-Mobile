import 'package:flutter/material.dart';
import 'package:m10/camera.dart';
import 'package:m10/contact.dart';
import 'package:permission_handler/permission_handler.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  void contact() async {
    int deniedCount = 0;

    while (deniedCount < 3) {
      if (await Permission.contacts.status.isGranted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactScreen()));
        return; // Exit the method if permission is granted
      } else {
        var status = await Permission.contacts.request();
        print(status);
        if (status == PermissionStatus.granted) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactScreen()));
          return; // Exit the method if permission is granted
        } else if (status == PermissionStatus.permanentlyDenied) {
          showSettingsDialog(); // Show dialog to navigate to settings
          return; // Exit the method as settings will be handled separately
        } else if (status == PermissionStatus.denied) {
          deniedCount++;
          if (deniedCount == 3) {
            showSettingsDialog(); // Show dialog to navigate to settings after 3 denied attempts
          } else {
            bool result = await showConfirmationDialog(); // Show confirmation dialog for 'Yes' or 'No'
            if (!result) {
              return; // Exit the method if 'No' is selected
            }
          }
        }
      }
    }
  }

  void camera() async {
    int deniedCount = 0;

    while (deniedCount < 3) {
      if (await Permission.camera.status.isGranted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraScreen()));
        return; // Exit the method if permission is granted
      } else {
        var status = await Permission.camera.request();
        print(status);
        if (status == PermissionStatus.granted) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraScreen()));
          return; // Exit the method if permission is granted
        } else if (status == PermissionStatus.permanentlyDenied) {
          showSettingsDialog(); // Show dialog to navigate to settings
          return; // Exit the method as settings will be handled separately
        } else if (status == PermissionStatus.denied) {
          deniedCount++;
          if (deniedCount == 3) {
            showSettingsDialog(); // Show dialog to navigate to settings after 3 denied attempts
          } else {
            bool result = await showConfirmationDialog(); // Show confirmation dialog for 'Yes' or 'No'
            if (!result) {
              return; // Exit the method if 'No' is selected
            }
          }
        }
      }
    }
  }

  Future<bool> showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission Confirmation"),
          content: Text("Do you want to request permission again?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false for 'No'
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true for 'Yes'
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showSettingsDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission Required"),
          content: Text("Please grant permission in app settings."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Open app settings
              },
              child: Text("Go to Settings"),
            ),
          ],
        );
      },
    );
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
            ElevatedButton(onPressed: () => camera(), child: Text("Camera"))
          ],
        ),
      ),
    );
  }
}
