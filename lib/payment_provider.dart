import 'dart:async';

import 'package:aguinha/common.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PaymentProvider with ChangeNotifier {
  InAppPurchase _iap = InAppPurchase.instance;
  bool available = true;
  StreamSubscription? subscription;
  final productId = 'basic_premium';

  Future<void> initialize() async {
    available = await _iap.isAvailable();
  }

  void verifyPurchases() {
    // PurchaseDetails purchase = null;
    // if (purchase != null && purchase.status == PurchaseStatus.purchased) {
    //   if (purchase.pendingCompletePurchase) {
    //     _iap.completePurchase(purchase);
    //     // isPurchased = true;
    //   }
    // }
  }

  // PurchaseDetails hasPurchased() {}
}
