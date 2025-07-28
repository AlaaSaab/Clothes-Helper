import 'package:google_mobile_ads/google_mobile_ads.dart';

/// A service responsible for initialising the Google Mobile Ads SDK and
/// providing helper methods to load and show banner and interstitial ads.
///
/// In this planning phase we only scaffold the API; actual ad unit
/// identifiers should be configured in later phases.  Make sure to
/// follow the [AdMob policies](https://support.google.com/admob/answer/6128543) when
/// integrating ads into your application.
class AdService {
  /// Example ad unit IDs.  Replace these with your own AdMob IDs when
  /// configuring ads for production.  Use test IDs during development.
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  InterstitialAd? _interstitialAd;

  /// Initialise the Mobile Ads SDK.  Call this early in the app's
  /// lifecycle (e.g. in main before runApp).
  Future<InitializationStatus> init() async {
    return MobileAds.instance.initialize();
  }

  /// Load an interstitial ad and cache it for display.  The loaded ad
  /// will be stored in [_interstitialAd] and replaced once shown.
  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Handle the error by logging or retrying later.
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Show the interstitial ad if it has been loaded.  After the ad is
  /// shown it will be disposed and a new one should be loaded.
  void showInterstitial() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          loadInterstitial();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          loadInterstitial();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  /// Create a banner ad.  This returns a [BannerAd] which can be
  /// attached to a [BannerAdWidget] in the UI.  You are responsible
  /// for managing the ad's lifecycle (loading/disposal) outside of this
  /// service.
  BannerAd createBannerAd({AdSize size = AdSize.banner}) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => {},
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );
  }
}
