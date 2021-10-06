import 'dart:async';
import 'dart:ui';

import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/home_screen/ad_section.dart';
import 'package:aguinha/screens/premium_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:aguinha/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen/custom_drawer.dart';
import 'home_screen/friends_section.dart';
import 'home_screen/main_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AguinhaUser currentUser;
  bool loadedUser = false;

  InAppPurchase _iap = InAppPurchase.instance;
  bool _available = true;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  late StreamSubscription _subscription;
  late ProductDetails subscription;

  Future<void> initialize() async {
    _available = await _iap.isAvailable();

    if (_available) {}
  }

  Future<void> _getPrducts() async {
    Set<String> ids = Set.from(['basic_premium']);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    print('produtos');

    setState(() {
      subscription = response.productDetails.first;
    });
    print(response.productDetails.first.id);
  }

  void _buySubscription(ProductDetails subscription) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: subscription);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        final snackBar = SnackBar(
            content: Text('${notification.title} também está bebendo água!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    _getPrducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => TextButton(
              child: Row(
                children: [
                  Text(
                    'MENU',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: kDefaultPadding / 2,
                  ),
                  Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      endDrawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: _size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainHeader(),
              Column(
                children: [
                  FriendsSection(),
                  SizedBox(
                    height: kDefaultPadding * 2,
                  ),
                  AdSection()
                  // TextButton(
                  //     onPressed: () {
                  //       Navigator.pushNamed(context, PremiumScreen.id);
                  //       // _buySubscription(subscription);
                  //     },
                  //     child: Text('Premium'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Drink {
  water,
  juice,
  milk,
  tea,
}
