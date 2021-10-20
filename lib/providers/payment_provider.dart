import 'dart:async';

import 'package:aguinha/shared/common.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentProvider with ChangeNotifier {
  InAppPurchase _iap = InAppPurchase.instance;
  // List<ProductDetails> get products => _products;

  final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

  late ProductDetails premium_details;

  late bool _isPremium = false;
  bool get isPremium => _isPremium;
  set isPremium(value) => _isPremium = value;

  List<PurchaseDetails> _purchases = [];
  List<PurchaseDetails> get purchases => _purchases;
  set purchases(List<PurchaseDetails> value) {
    _purchases = value;
    notifyListeners();
  }

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;
  set products(List<ProductDetails> value) {
    _products = value;
    notifyListeners();
  }

  bool available = true;
  StreamSubscription? _subscription;
  final _premiumID = 'basic_premium';

  Future<void> initialize() async {
    available = await _iap.isAvailable();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isPremium = prefs.getBool('isPremium') ?? false;
    notifyListeners();

    if (available) {
      _getProducts();

      final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription!.cancel();
      }, onError: (error) {
        // handle error here.
      });
    }
    InAppPurchase.instance.restorePurchases();
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    print(purchaseDetailsList);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (purchaseDetailsList.isEmpty) {
      isPremium = false;
      prefs.setBool('isPremium', false);
    }
    if (purchaseDetailsList.isEmpty) prefs.setBool('isPremium', false);
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print(purchaseDetails);
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print(purchaseDetails.error!.details);
          print(purchaseDetails.error!.message);
          isPremium = false;
          prefs.setBool('isPremium', false);
          notifyListeners();
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          isPremium = true;
          await prefs.setBool('isPremium', true);
          notifyListeners();
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
          isPremium = true;
          await prefs.setBool('isPremium', true);
          notifyListeners();
        }
      }
    });
  }

  Future<void> verifyPurchases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      PurchaseDetails purchase = hasPurchased(_premiumID);
      if (purchase.status == PurchaseStatus.purchased) {
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
          prefs.setBool('isPremium', true);
        }
      } else {
        prefs.setBool('isPremium', false);
      }
    } catch (error) {
      prefs.setBool('isPremium', false);
    }
  }

  PurchaseDetails hasPurchased(String productID) {
    print(productID);
    print(purchases);
    return purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => throw 'hasn\'t purchased');
  }
  // PurchaseDetails hasPurchased() {}

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([_premiumID]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    products = response.productDetails;
  }

  Future<void> buySubscription() async {
    try {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: products.first);
      await _iap.buyConsumable(purchaseParam: purchaseParam);
    } catch (error) {
      throw 'serviço de pagamentos indisponível';
    }
  }
}
