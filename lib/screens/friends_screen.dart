import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/api.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/friends_screen/sections/received_invites_section.dart';
import 'package:aguinha/screens/friends_screen/sections/sent_requests_sections.dart';
import 'package:aguinha/screens/username_screen.dart';
import 'package:aguinha/ui/subtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'add_friend_screen.dart';
import 'package:aguinha/common.dart';
import 'error_screen.dart';
import 'login_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);
  static String id = 'friends_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.friendsRequests),
          backgroundColor: kPrimaryColor,
          elevation: 0,
          shape: Border.all(width: 0, color: kPrimaryColor),
          actions: [
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddUserScreen()));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SvgPicture.asset(
              'assets/nav_background.svg',
              alignment: Alignment.topLeft,
              fit: BoxFit.fitWidth,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 2, vertical: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle(title: AppLocalizations.of(context)!.received),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: API.getReceivedRequests(),
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
                            return Text('nenhuma solicitação');
                          List<ReceivedRequestTile> requestsWidgets = [];
                          for (var request in receivedRequests) {
                            print(request.get('nickname'));
                            receivedRequests.indexOf(request);

                            requestsWidgets.add(
                              ReceivedRequestTile(AguinhaUser(
                                  request.id,
                                  request.get('nickname'),
                                  request.get('suffix'))),
                            );
                          }
                          return Column(
                            children: requestsWidgets,
                          );
                        },
                      ),
                    ],
                  ),
                  // FriendRequestTile(),
                  SizedBox(
                    height: kDefaultPadding * 3,
                  ),
                  Subtitle(title: AppLocalizations.of(context)!.sent),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: API.getSentRequests(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                            );
                          }
                          final sentRequests = snapshot.data!.docs;
                          if (sentRequests.isEmpty)
                            return Text('nenhuma solicitação');
                          List<SentRequestTile> requestsWidgets = [];
                          for (var request in sentRequests) {
                            print(request.get('nickname'));
                            sentRequests.indexOf(request);

                            requestsWidgets.add(
                              SentRequestTile(
                                AguinhaUser(
                                  request.id,
                                  request.get('nickname'),
                                  request.get('suffix'),
                                ),
                              ),
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
            )
          ],
        ),
      ),
    );
  }
}

class ReceivedRequestTile extends StatelessWidget {
  const ReceivedRequestTile(this.requester);

  final AguinhaUser requester;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final acceptRequest = await showModalBottomSheet(
            backgroundColor: kPrimaryColor,
            context: context,
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'aceitar solicitação de amizade?',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: kDefaultPadding * 4,
                  ),
                  Text(
                    requester.nickname,
                    style: TextStyle(color: Color(0xFF7FBFE5), fontSize: 36),
                  ),
                  Text(
                    '#${requester.suffix}',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Color(0xFFB0D9EF), fontSize: 24),
                  ),
                  SizedBox(
                    height: kDefaultPadding * 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 4,
                                vertical: kDefaultPadding),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Colors.white)),
                            child: Text(
                              'não',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 4,
                                vertical: kDefaultPadding),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: kPrimaryColor)),
                            child: Text(
                              'sim',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  )
                ],
              );
            });
        if (acceptRequest != null) {
          try {
            final snackBar =
                SnackBar(content: Text('aceitando solicitação...'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            await API.acceptFriendshipRequest(requester);
          } catch (error) {
            final errorSnackBar = SnackBar(
                content: Text(AppLocalizations.of(context)!.unknownError));
            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
          }
        }
      },
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  'assets/whale_icon.svg',
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
          SizedBox(
            width: kDefaultPadding / 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                requester.nickname,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
              Text(
                '#${requester.suffix}',
                style: TextStyle(color: Color(0xFF4B9CCB)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SentRequestTile extends StatelessWidget {
  const SentRequestTile(this.friend);

  final AguinhaUser friend;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final deleteRequest = await showModalBottomSheet(
            backgroundColor: kPrimaryColor,
            context: context,
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'excluir solicitação de amizade?',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: kDefaultPadding * 4,
                  ),
                  Text(
                    friend.nickname,
                    style: TextStyle(color: Color(0xFF7FBFE5), fontSize: 36),
                  ),
                  Text(
                    '#${friend.suffix}',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Color(0xFFB0D9EF), fontSize: 24),
                  ),
                  SizedBox(
                    height: kDefaultPadding * 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 4,
                                vertical: kDefaultPadding),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Colors.white)),
                            child: Text(
                              'cancelar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      // SizedBox(
                      //   width: kDefaultPadding,
                      // ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 4,
                                vertical: kDefaultPadding),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: kPrimaryColor)),
                            child: Text(
                              'excluir',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  )
                ],
              );
            });
        if (deleteRequest != null) {
          try {
            final snackBar =
                SnackBar(content: Text('excluindo solicitação...'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            await API.denyFriendRequest(friend);
          } catch (error) {
            final errorSnackBar = SnackBar(
                content: Text('não foi possível excluir a solicitação'));
            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
          }
        }
      },
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  'assets/whale_icon.svg',
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
          SizedBox(
            width: kDefaultPadding / 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friend.nickname,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
              Text(
                '#${friend.suffix}',
                style: TextStyle(color: Color(0xFF4B9CCB)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
