import 'package:aguinha/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  static String id = 'friends_screen';

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: kPrimaryColor,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Amigos'),
            ),
            expandedHeight: _size.height * 0.4,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: kDefaultPadding * 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: kDefaultPadding),
                  child: Text(
                    'Convite por nome de usuário',
                    style: kSubheaderStyle,
                  ),
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                UserSearchSection(),
                ReceivedInvitesSection(),
                SizedBox(
                  height: kDefaultPadding / 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: kDefaultPadding),
                  child: Text(
                    'Convites enviados',
                    style: kSubheaderStyle,
                  ),
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('sentRequests')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                          );
                        }

                        final receivedRequests = snapshot.data!.docs;
                        if (receivedRequests.isEmpty)
                          return Text('Nenhum convite pendente');
                        List<Text> requestsWidgets = [];
                        for (var request in receivedRequests) {
                          print(request.get('nickname'));
                          receivedRequests.indexOf(request);
                          requestsWidgets.add(Text(request.get('nickname'))
                              // FriendTile(index: friends.indexOf(friend), friend: friend),
                              );
                        }
                        return Column(
                          children: requestsWidgets,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class ReceivedInvitesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kDefaultPadding * 3,
        ),
        Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: Text(
            'Convites recebidos',
            style: kSubheaderStyle,
          ),
        ),
        SizedBox(
          height: kDefaultPadding,
        ),
        Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('receivedRequests')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final receivedRequests = snapshot.data!.docs;
                if (receivedRequests.isEmpty)
                  return Text('Nenhum convite pendente');
                List<Text> requestsWidgets = [];

                for (var request in receivedRequests) {
                  print(request.get('nickname'));
                  receivedRequests.indexOf(request);
                  requestsWidgets.add(Text(request.get('nickname'))
                      // FriendTile(index: friends.indexOf(friend), friend: friend),
                      );
                }
                return Column(
                  children: requestsWidgets,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class UserSearchSection extends StatefulWidget {
  @override
  _UserSearchSectionState createState() => _UserSearchSectionState();
}

class _UserSearchSectionState extends State<UserSearchSection> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    String? username;

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      color: kPrimaryColor,
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              username = value;
            },
            enabled: !loading,
            textCapitalization: TextCapitalization.characters,
            style: TextStyle(color: Colors.white, fontSize: kMediumFontSize),
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white60),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () async {
                    if (username == null || username!.isEmpty) {
                      final snackBar =
                          SnackBar(content: Text('Insira um nome de usuário'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    setState(() {
                      loading = true;
                    });

                    HttpsCallable callable =
                        FirebaseFunctions.instance.httpsCallable('userExists');
                    final userExists =
                        await callable.call({'username': username});

                    setState(() {
                      loading = false;
                    });
                    if (userExists.data) {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'Deseja enviar uma solicitação de amizade para'),
                              SizedBox(
                                height: kDefaultPadding * 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'AUSTRAL',
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('#2424',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 24,
                                          color: Colors.grey)),
                                ],
                              ),
                              SizedBox(
                                height: kDefaultPadding,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      HttpsCallable callable = FirebaseFunctions
                                          .instance
                                          .httpsCallable('requestFriendship');
                                      final response = await callable
                                          .call({'username': username});
                                      if (response.data) {
                                        Navigator.pop(context);
                                        final snackBar = SnackBar(
                                            content:
                                                Text('Solicitação enviada!'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: kPrimaryColor),
                                    child: Text('Sim'),
                                  ),
                                  SizedBox(
                                    width: kDefaultPadding,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Não',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      final snackBar =
                          SnackBar(content: Text('Usuário não encontrado'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    print(userExists.data);
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: kBigIconSize,
                  ),
                ),
                hintText: 'Insira um e-mail...',
                fillColor: Colors.white),
          ),
          if (loading) LinearProgressIndicator()
        ],
      ),
    );
  }
}
