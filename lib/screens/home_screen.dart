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
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AguinhaUser currentUser;
  bool loadedUser = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print(notification.title);
        print(message.notification!.android!.channelId);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        final snackBar = SnackBar(
            content: Text('${notification.title} também está bebendo água!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    API.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
        loadedUser = true;
      });
    }).catchError((error) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UsernameScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xff2bd3ff), Color(0xff015afb)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SvgPicture.asset(
                'assets/top_background.svg',
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 2,
                      vertical: kDefaultPadding * 4),
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
                      if (loadedUser)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.nickname,
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
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Text(''),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(Icons.local_drink),
            //     SizedBox(
            //       width: kDefaultPadding / 2,
            //     ),
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text('notificar'),
            //         Text('todos'),
            //       ],
            //     )
            //   ],
            // ),
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
                final friends = snapshot.data!.docs;
                List<FriendTile> friendsWidgets = [];

                for (var friend in friends) {
                  var aguinhaFriend = AguinhaUser(
                      friend.id, friend['nickname'], friend['suffix']);
                  friends.indexOf(friend);
                  friendsWidgets.add(
                    FriendTile(aguinhaFriend),
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
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider
                                .logout()
                                .then((value) => Navigator.pop(context))
                                .catchError((error) {
                              Navigator.pop(context);
                              final snackBar =
                                  SnackBar(content: Text('algo deu errado'));
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
                          });
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
          )
        ],
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  const FriendTile(this.friend);

  final AguinhaUser friend;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(kDefaultPadding),
      child: TextButton(
        onPressed: () async {
          await API.notify(friend);
          final snackBar =
              SnackBar(content: Text('${friend.nickname} foi notificado'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onLongPress: () {},
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
                  color: kPrimaryColor,
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
            Text(
              friend.nickname,
              style: TextStyle(color: kPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
