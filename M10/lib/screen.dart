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
  int noButtonPressedCount = 0;

  void contact() async {
    if (await Permission.contacts.status.isGranted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactScreen()));
    } else {
      var status = await Permission.contacts.request();
      print(status);
      if (status == PermissionStatus.granted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactScreen()));
      } else if (status == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      }
    }
  }

  void photos() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission"),
          content: Text("Allow access to photos?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Handle 'Yes' action here
                // You can navigate to PhotoScreen or perform any other actions
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission Denied"),
          content: Text("Please go to settings to allow access."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
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
            ElevatedButton(
              onPressed: () => contact(),
              child: Text("Contact"),
            ),
            ElevatedButton(
              onPressed: () => photos(),
              child: Text("Photos"),
            ), // Changed from "Camera" to "Photos"
            ElevatedButton(
              onPressed: () {
                if (noButtonPressedCount < 2) {
                  // Show the 'No' dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirmation"),
                        content: Text("Are you sure?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              // Handle 'Yes' action here
                              // You can navigate to PhotoScreen or perform any other actions
                            },
                            child: Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Show the settings dialog
                  showSettingsDialog();
                }
                setState(() {
                  noButtonPressedCount++;
                });
              },
              child: Text("Check Dialog"),
            ),
          ],
        ),
      ),
    );
  }
}
