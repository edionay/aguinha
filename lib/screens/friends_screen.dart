import 'package:aguinha/api.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/friends_screen/sections/received_invites_section.dart';
import 'package:aguinha/screens/friends_screen/sections/sent_requests_sections.dart';
import 'package:aguinha/screens/username_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'error_screen.dart';
import 'friends_screen/sections/user_search_section.dart';
import 'login_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);
  static String id = 'friends_screen';

  @override
  Widget build(BuildContext context) {
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
            expandedHeight: 300,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  children: [],
                ),
                UserSearchSection(),
                ReceivedInvitesSection(),
                SentRequestsSection(),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
