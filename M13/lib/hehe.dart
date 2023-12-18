import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'managers/ads_manager.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adsManager = context.watch<AdsManager>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Your App Title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (adsManager.showInterstitialAds)
              ElevatedButton(
                onPressed: () {
                  _showInterstitialBeforeNavigate(context);
                },
                child: Text("Go to Home with Ads"),
              ),
            if (adsManager.showBannerAd)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  // Your banner ad widget
                  // Replace this with your actual banner ad widget
                  width: 320.0,
                  height: 50.0,
                  color: Colors.blueGrey,
                  child: Center(
                    child: Text('Banner Ad'),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Assuming 1000 rupiah payment to remove ads
                  bool paymentSuccessful = adsManager.makePayment(1000);

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

  void _showInterstitialBeforeNavigate(BuildContext context) {
    final adsManager = context.read<AdsManager>();

    // Load and show interstitial ad
    // ... (Your interstitial ad loading and showing logic)

    // When the interstitial ad is dismissed, navigate to HomeScreen
    // Set the callback to null to avoid unwanted navigation on subsequent dismissals
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        // Navigate to the HomeScreen after the interstitial ad is dismissed
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        // Set the callback to null to avoid unwanted navigation on subsequent dismissals
        interstitialAd.fullScreenContentCallback = null;
      },
    );

    interstitialAd.show();
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: Text("This is the home screen."),
      ),
    );
  }
}
