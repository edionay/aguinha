import 'package:aguinha/api.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/friends_screen.dart';
import 'package:aguinha/screens/username_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../provider.dart';

const waterColors = [
  Color(0xFF0466C8),
  Color(0xFF0353A4),
  Color(0xFF023E7D),
  Color(0xFF002855),
  Color(0xFF001845),
  Color(0xFF001233),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    API.hasUsername().then((hasUsername) {
      print(hasUsername);
      if (!hasUsername)
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
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Aguinha',
                  style: new TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = linearGradient),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.group_add),
                    padding: EdgeInsets.all(kDefaultPadding),
                    color: Colors.white,
                    iconSize: 40.0,
                    onPressed: () {
                      Navigator.pushNamed(context, FriendsScreen.id);
                    },
                  ),
                )
              ],
            ),
            Column(
              children: [
                StreamBuilder<QuerySnapshot>(
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
                      friends.indexOf(friend);
                      friendsWidgets.add(
                        FriendTile(
                            index: friends.indexOf(friend), friend: friend),
                      );
                    }
                    return Column(
                      children: friendsWidgets,
                    );
                  },
                ),
              ],
            ),
          ],
        ));
  }
}

class FriendTile extends StatefulWidget {
  const FriendTile({
    Key? key,
    required this.index,
    required this.friend,
  }) : super(key: key);

  final int index;
  final QueryDocumentSnapshot<Object?> friend;

  @override
  _FriendTileState createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  var loading = false;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: loading ? false : true,
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            primary: waterColors[widget.index],
            onSurface: waterColors[widget.index]),
        onPressed: loading
            ? null
            : () async {
                setState(() {
                  loading = true;
                });
                HttpsCallable callable =
                    FirebaseFunctions.instance.httpsCallable('notify');
                final response = await callable.call({'to': widget.friend.id});
                final snackBar = SnackBar(
                    content:
                        Text('${widget.friend['nickname']} foi notificado!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                setState(() {
                  loading = false;
                });
              },
        child: Column(
          children: [
            Container(
              // color: Color(0xFF0052F1),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                widget.friend['nickname'],
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (loading) LinearProgressIndicator()
          ],
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => {},
        ),
      ],
    );
  }
}
