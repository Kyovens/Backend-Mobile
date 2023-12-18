import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int coin = 0;
  late BannerAd _bannerAd;
  bool _isBannerReady = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialReady = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AdMob"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monetization_on,
                    size: 50,
                  ),
                  Text(
                    coin.toString(),
                    style: TextStyle(fontSize: 50),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _showInterstitialBeforeNavigate();
                },
                child: Text("Go to Home"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _loadRewardedAd();
                  if (_isRewardedReady) {
                    _rewardedAd.show(
                      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                        setState(() {
                          coin += 1;
                        });
                        if (coin == 10) {
                          // Assuming 10 coins represent 10000 rupiah payment
                          context.read<AdsManager>().hideAds();
                        }
                      },
                    );
                  }
                },
                child: Text("Pay 10000 Rupiah to Remove Ads"),
              ),
            ),
            Expanded(
              child: context.watch<AdsManager>().showAds
                  ? _isBannerReady
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: _bannerAd.size.width.toDouble(),
                            height: _bannerAd.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd),
                          ),
                        )
                      : Container()
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  void _loadBannedAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerReady = true;
          });
        }, onAdFailedToLoad: (ad, err) {
          _isBannerReady = false;
          ad.dispose();
        }),
        request: AdRequest());
    _bannerAd.load();
  }

  void _loadInterstisialAdd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          setState(() {
            _isInterstitialReady = true;
            _interstitialAd = ad;
          });
        }, onAdFailedToLoad: (err) {
          _isInterstitialReady = false;
          _interstitialAd.dispose();
        }));
  }

  void _loadRewardedAd() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5224354917",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
            setState(() {
              ad.dispose();
              _isRewardedReady = false;
            });
            _loadRewardedAd();
          });
          setState(() {
            _isRewardedReady = true;
            _rewardedAd = ad;
          });
        }, onAdFailedToLoad: (err) {
          _isRewardedReady = false;
          _rewardedAd.dispose();
        }));
  }

  void _showInterstitialBeforeNavigate() {
    _loadInterstisialAdd();
    if (_isInterstitialReady) {
      _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          // Navigate to the HomeScreen after the interstitial ad is dismissed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          // Set the callback to null to avoid unwanted navigation on subsequent dismissals
          _interstitialAd.fullScreenContentCallback = null;
        },
      );
      _interstitialAd.show();
    } else {
      // If the interstitial ad is not ready, navigate directly
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
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
