import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
                    List<ElevatedButton> friendsWidgets = [];

                    for (var friend in friends) {
                      friends.indexOf(friend);
                      friendsWidgets.add(
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0))),
                              primary: waterColors[friends.indexOf(friend)]),
                          onPressed: () async {
                            HttpsCallable callable = FirebaseFunctions.instance
                                .httpsCallable('notify');
                            final response = await callable
                                .call({'to': friend.id, 'from': 'EDIONAY'});
                            print(response.data);
                          },
                          child: Container(
                            // color: Color(0xFF0052F1),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              friend['nickname'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
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
