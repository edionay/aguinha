import 'package:aguinha/components/home/sections/ad_section.dart';
import 'package:aguinha/components/home/sections/custom_drawer.dart';
import 'package:aguinha/components/home/sections/friends_section.dart';
import 'package:aguinha/components/home/sections/main_header.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/providers/drink_provider.dart';
import 'package:aguinha/providers/payment_provider.dart';
import 'package:aguinha/providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:aguinha/shared/common.dart';

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

    return ChangeNotifierProvider(
      create: (context) => DrinkProvider(),
      child: Scaffold(
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
