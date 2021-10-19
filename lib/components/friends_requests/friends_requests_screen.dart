import 'package:aguinha/common.dart';

import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/api.dart';
import 'package:aguinha/components/friends_requests/sections/received_request_tile.dart';
import 'package:aguinha/components/friends_requests/sections/received_requests_section.dart';
import 'package:aguinha/components/friends_requests/sections/sent_request_tile.dart';
import 'package:aguinha/components/friends_requests/sections/sent_requests_section.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/add_friend_screen.dart';
import 'package:aguinha/ui/subtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FriendsRequestsScreen extends StatelessWidget {
  const FriendsRequestsScreen({Key? key}) : super(key: key);
  static String id = 'friends_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ReceivedRequestsSection(),
                SizedBox(
                  height: kDefaultPadding * 3,
                ),
                SentRequestsSection()
              ],
            ),
          )
        ],
      ),
    );
  }
}
