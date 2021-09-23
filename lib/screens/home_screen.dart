import 'dart:ui';

import 'package:aguinha/ad_state.dart';
import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/api.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/provider.dart';
import 'package:aguinha/screens/add_friend_screen.dart';
import 'package:aguinha/screens/friends_screen.dart';
import 'package:aguinha/ui/subtitle.dart';
import 'package:aguinha/screens/username_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AguinhaUser currentUser;
  bool loadedUser = false;
  List<AguinhaUser> friends = [];
  List<FriendTile> friendsWidgets = [];
  bool notifying = false;
  String? appVersion;
  BannerAd? banner;

  void launchURL() async {
    final _url =
        'mailto:aguinha@edionay.com?subject=Tenho algo a dizer sobre o aguinha&body=';
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
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
            size: AdSize.banner,
            adUnitId: adState.bannerAdUnitId,
            listener: adState.adListenet,
            request: AdRequest())
          ..load();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    API.getCurrentUser().catchError((error) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UsernameScreen()),
          (route) => false);
    });

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) => setState(() {
          appVersion = packageInfo.version;
        }));

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
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: _size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        color: kPrimaryColor,
                        height: 250,
                        child: SvgPicture.asset(
                          'assets/main_background.svg',
                          excludeFromSemantics: true,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomLeft,
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: kDefaultPadding * 2,
                              top: kDefaultPadding * 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'aguinha',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: kDefaultPadding,
                              ),
                              FutureBuilder(
                                  future: API.getCurrentUser(),
                                  builder: (context,
                                      AsyncSnapshot<AguinhaUser> snapshot) {
                                    if (snapshot.hasData) {
                                      final currentUser = snapshot.data;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentUser!.nickname,
                                            style: TextStyle(
                                                color: Color(0xFF7FBFE5),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '#${currentUser.suffix}',
                                            style: TextStyle(
                                                color: Color(0xFFB0D9EF),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  }),
                            ],
                          ),
                        ),
                      ),
                      if (appVersion != null)
                        Positioned(
                          bottom: kDefaultPadding,
                          right: kDefaultPadding,
                          child: Text(
                            'versão ${appVersion!}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                    ],
                  ),
                  Container(
                    child: SvgPicture.asset(
                      'assets/nav_background.svg',
                      excludeFromSemantics: true,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topLeft,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: TextButton(
                      onPressed: notifying
                          ? null
                          : () async {
                              print('Notificar a galera');
                              setState(() {
                                notifying = true;
                              });

                              List<Future> notifications = [];
                              try {
                                for (var friend in friends) {
                                  notifications.add(API.notify(friend));
                                }
                                await Future.wait(notifications);
                                print('deu bom');
                                setState(() {
                                  notifying = false;
                                });
                              } catch (error) {
                                print(error.toString());
                                print('deu erro');
                                setState(() {
                                  notifying = false;
                                });
                              }
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(kDefaultPadding),
                                child: Icon(
                                  Icons.local_drink,
                                  size: 40,
                                  color:
                                      notifying ? Colors.grey : kPrimaryColor,
                                ),
                              )),
                          SizedBox(
                            width: kDefaultPadding / 2,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'notificar',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: notifying
                                        ? Colors.grey
                                        : kPrimaryColor),
                              ),
                              Text(
                                'todos',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: notifying
                                        ? Colors.grey
                                        : kPrimaryColor),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: kDefaultPadding * 2, bottom: kDefaultPadding / 2),
                    child: Subtitle(title: 'amigos'),
                  ),
                  Container(
                    height: 130,
                    padding: EdgeInsets.only(left: kDefaultPadding * 2),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('friends')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                          );
                        }
                        final friendsDocuments = snapshot.data!.docs;

                        friendsWidgets = [];
                        friends = [];
                        for (var friend in friendsDocuments) {
                          var aguinhaFriend = AguinhaUser(friend.id,
                              friend.get('nickname'), friend.get('suffix'));
                          friendsDocuments.indexOf(friend);
                          DateTime? lastSentNotification;
                          DateTime? lastReceivedNotification;
                          DateTime today = DateTime.now();
                          try {
                            Timestamp timestamp =
                                friend.get('lastSentNotification');
                            lastSentNotification = timestamp.toDate();
                          } catch (error) {}
                          try {
                            Timestamp timestamp =
                                friend.get('lastReceivedNotification');
                            lastReceivedNotification = timestamp.toDate();
                          } catch (error) {}
                          friends.add(aguinhaFriend);
                          friendsWidgets.add(
                            FriendTile(
                                friend: aguinhaFriend,
                                notifying: notifying,
                                lastSentNotification: lastSentNotification,
                                lastReceivedNotification:
                                    lastReceivedNotification),
                          );
                        }
                        return GridView.count(
                          // primary: true,
                          shrinkWrap: true,
                          // crossAxisSpacing: 20,
                          // mainAxisSpacing: 20,
                          childAspectRatio: 0.4,
                          // physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          scrollDirection: Axis.horizontal,
                          children: friendsWidgets,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: kDefaultPadding * 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AddUserScreen.id);
                            },
                            tooltip: 'adicionar amigo',
                            icon: Icon(
                              Icons.person_add,
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(
                        width: kDefaultPadding,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            tooltip: 'solicitações de amizade',
                            onPressed: () {
                              Navigator.pushNamed(context, FriendsScreen.id);
                            },
                            icon: Icon(
                              Icons.group,
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(
                        width: kDefaultPadding,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            onPressed: () {
                              launchURL();
                            },
                            tooltip: 'suporte',
                            icon: Icon(
                              Icons.feedback,
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(
                        width: kDefaultPadding,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            tooltip: 'sair',
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  final provider =
                                      Provider.of<GoogleSignInProvider>(context,
                                          listen: false);
                                  provider
                                      .logout()
                                      .then((value) => Navigator.pop(context))
                                      .catchError((error) {
                                    Navigator.pop(context);
                                    final snackBar = SnackBar(
                                        content: Text(error.toString()));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
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
                            icon: Icon(
                              Icons.logout,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: kDefaultPadding * 2,
                  ),
                  if (banner == null)
                    SizedBox(
                      height: 50,
                    )
                  else
                    Container(
                      height: 50,
                      child: AdWidget(
                        ad: banner!,
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FriendTile extends StatefulWidget {
  const FriendTile(
      {required this.friend,
      required this.notifying,
      this.lastSentNotification,
      this.lastReceivedNotification});
  final bool notifying;
  final AguinhaUser friend;

  final DateTime? lastSentNotification, lastReceivedNotification;

  @override
  _FriendTileState createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(kDefaultPadding),
      child: TextButton(
        onLongPress: disabled || widget.notifying
            ? null
            : () async {
                final bool? unfriend = await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      color: kPrimaryColor,
                      child: Column(
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.friend.nickname,
                                  style: TextStyle(
                                      color: Color(0xFF7FBFE5), fontSize: 36),
                                ),
                                Text(
                                  '#${widget.friend.suffix}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Color(0xFFB0D9EF), fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding * 4,
                                  vertical: kDefaultPadding * 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Text(
                                'desfazer amizade',
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: kDefaultPadding * 2),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'voltar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
                if (unfriend != null) {
                  API.unfriend(widget.friend);
                  final snackBar =
                      SnackBar(content: Text('desfazendo amizade...'));

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
        onPressed: disabled || widget.notifying
            ? null
            : () async {
                setState(() {
                  disabled = true;
                });
                try {
                  await API.notify(widget.friend);
                  setState(() {
                    disabled = false;
                  });
                } catch (error) {
                  setState(() {
                    disabled = false;
                  });
                }
              },
        style: TextButton.styleFrom(
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                  color: disabled || widget.notifying
                      ? Colors.grey
                      : kPrimaryColor,
                  borderRadius: BorderRadius.circular(40)),
              child: SvgPicture.asset(
                'assets/whale_icon.svg',
                alignment: Alignment.center,
                // fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              width: kDefaultPadding / 2,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.friend.nickname,
                    maxLines: 1,
                    style: TextStyle(
                        color: disabled || widget.notifying
                            ? Colors.grey
                            : kPrimaryColor),
                  ),
                  if (widget.lastSentNotification != null)
                    Row(
                      children: [
                        Transform.rotate(
                          angle: 200,
                          child: Icon(
                            Icons.arrow_forward,
                            size: 10,
                            semanticLabel: 'última notificação enviada',
                          ),
                        ),
                        Text(
                          '${widget.lastSentNotification!.hour}:${widget.lastSentNotification!.minute}',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  if (widget.lastReceivedNotification != null)
                    Row(
                      children: [
                        Transform.rotate(
                          angle: 200,
                          child: Icon(
                            Icons.arrow_back,
                            size: 10,
                            semanticLabel: 'última notificação recebida',
                          ),
                        ),
                        Text(
                          '${widget.lastReceivedNotification!.hour}:${widget.lastReceivedNotification!.minute}',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
