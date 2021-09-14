import 'dart:ui';

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
import 'package:provider/provider.dart';

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
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      FutureBuilder(
                          future: API.getCurrentUser(),
                          builder:
                              (context, AsyncSnapshot<AguinhaUser> snapshot) {
                            if (snapshot.hasData) {
                              final currentUser = snapshot.data;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
              )
            ],
          ),
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: () async {
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
                            color: notifying ? Colors.grey : kPrimaryColor,
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
                              color: notifying ? Colors.grey : kPrimaryColor),
                        ),
                        Text(
                          'todos',
                          style: TextStyle(
                              fontSize: 20,
                              color: notifying ? Colors.grey : kPrimaryColor),
                        )
                      ],
                    )
                  ],
                ),
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
                  var aguinhaFriend = AguinhaUser(
                      friend.id, friend['nickname'], friend['suffix']);
                  friendsDocuments.indexOf(friend);
                  friends.add(aguinhaFriend);
                  friendsWidgets.add(
                    FriendTile(aguinhaFriend, notifying),
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
                                  SnackBar(content: Text(error.toString()));
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

class FriendTile extends StatefulWidget {
  const FriendTile(this.friend, this.notifying);
  final notifying;

  final AguinhaUser friend;
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
                  final snackBar = SnackBar(
                      content:
                          Text('${widget.friend.nickname} foi notificado'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } catch (error) {
                  print(error.toString());
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friend.nickname,
                  style: TextStyle(
                      color: disabled || widget.notifying
                          ? Colors.grey
                          : kPrimaryColor),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      size: 10,
                    ),
                    Text(
                      '22:00',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 10,
                    ),
                    Text(
                      '22:00',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
