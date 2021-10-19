import 'dart:async';

import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/payment_provider.dart';
import 'package:aguinha/screens/home_screen/ad_section.dart';
import 'package:aguinha/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:aguinha/common.dart';
import 'home_screen/custom_drawer.dart';
import 'home_screen/friends_section.dart';
import 'home_screen/main_header.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loadedUser = false;

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

    context.read<UserProvider>().initialize();
    context.read<PaymentProvider>().initialize();

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
  coffee,
  juice,
  milk,
  tea,
  wine,
  beer,
}
