import 'package:flutter/material.dart';

import 'app.dart';
import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise the Google Mobile Ads SDK.  This future can be awaited
  // but we don't need to block app startup on ad loading.
  final adService = AdService();
  await adService.init();
  // Pre‑load an interstitial ad for later use.
  AdService.loadInterstitial();
  runApp(const ClothesHelperApp());
}
