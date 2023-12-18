import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'managers/ads_manager.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your App Title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your existing widgets

            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Assuming 1000 rupiah payment to hide ads
                  bool paymentSuccessful =
                      context.read<AdsManager>().makePayment(1000);

                  if (paymentSuccessful) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ads removed successfully!'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Insufficient payment amount.'),
                      ),
                    );
                  }
                },
                child: Text("Pay 1000 Rupiah to Remove Ads"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
