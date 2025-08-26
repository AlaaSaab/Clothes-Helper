import 'package:in_app_purchase/in_app_purchase.dart';

/// Service handling in‑app purchases.  This class is currently a stub
/// and does not perform any real purchase logic.  In Phase 3 you
/// would implement methods to query available products, initiate
/// purchases and verify receipts with your backend.
class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;

  /// Check whether in‑app purchases are available on the current
  /// platform.  Returns a [bool].
  Future<bool> isAvailable() async {
    return _iap.isAvailable();
  }

  /// A placeholder method to start a purchase flow.  In a real
  /// implementation this would take a [ProductDetails] and call
  /// [buyNonConsumable] or [buyConsumable].
  Future<void> buyVip() async {
    // TODO: implement purchase logic in a future phase.
  }
}
