import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_service.dart';

/// A reusable widget that wraps a banner ad.  It loads the ad on
/// initialisation and disposes of it when removed from the widget tree.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key, this.size});

  /// The size of the banner.  Defaults to the standard banner size.
  final AdSize? size;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final adService = AdService();
    final ad = adService.createBannerAd(size: widget.size ?? AdSize.banner);
    ad.load();
    ad.listener = BannerAdListener(
      onAdLoaded: (Ad ad) {
        setState(() {
          _bannerAd = ad as BannerAd;
          _isLoaded = true;
        });
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox(height: 0);
    }
    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
