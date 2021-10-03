import 'dart:ui';

import 'package:aguinha/ad_state.dart';
import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/api.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/provider.dart';
import 'package:aguinha/screens/add_friend_screen.dart';
import 'package:aguinha/screens/friends_screen.dart';
import 'package:aguinha/screens/settings_screen.dart';
import 'package:aguinha/ui/subtitle.dart';
import 'package:aguinha/screens/username_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aguinha/common.dart';

import 'home_screen/bottom_menu_section.dart';
import 'home_screen/friends_section.dart';
import 'home_screen/main_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AguinhaUser currentUser;
  bool loadedUser = false;

  void launchURL() async {
    final _url =
        'mailto:aguinha@edionay.com?subject=${AppLocalizations.of(context)!.supportMailTitle}&body=';
    try {
      await canLaunch(_url)
          ? await launch(_url)
          : throw 'Could not launch $_url';
    } catch (error) {
      print(error);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        final snackBar = SnackBar(
            content: Text('${notification.title} também está bebendo água!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
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
      endDrawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Column(
                children: [],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text(AppLocalizations.of(context)!.addFriend),
              onTap: () {
                Navigator.popAndPushNamed(context, AddUserScreen.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text(AppLocalizations.of(context)!.friendsRequests),
              onTap: () {
                Navigator.popAndPushNamed(context, FriendsScreen.id);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text(AppLocalizations.of(context)!.support),
              onTap: () {
                launchURL();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settings),
              onTap: () {
                Navigator.popAndPushNamed(context, SettingsScreen.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logout),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider
                        .logout()
                        .then((value) => Navigator.pop(context))
                        .catchError((error) {
                      Navigator.pop(context);
                      final snackBar =
                          SnackBar(content: Text(error.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                    return Container(
                      height: 100,
                      color: kPrimaryColor,
                      child: Center(
                          child: Text(
                        'saindo...',
                        style: TextStyle(color: Colors.white),
                      )),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
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
