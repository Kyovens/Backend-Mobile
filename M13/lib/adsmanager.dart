import 'package:flutter/foundation.dart';

class AdsManager extends ChangeNotifier {
  bool _showInterstitialAds = true;
  bool _showBannerAd = true;

  bool get showInterstitialAds => _showInterstitialAds;
  bool get showBannerAd => _showBannerAd;

  void hideInterstitialAds() {
    _showInterstitialAds = false;
    notifyListeners();
  }

  void hideBannerAd() {
    _showBannerAd = false;
    notifyListeners();
  }

  bool makePayment(double amount) {
    // Assume 1000 rupiah payment removes ads
    if (amount >= 1000) {
      hideInterstitialAds();
      hideBannerAd();
      return true; // Payment successful
    }
    return false; // Insufficient payment
  }
}
