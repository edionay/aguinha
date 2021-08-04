import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/friends_screen/sections/received_invites_section.dart';
import 'package:aguinha/screens/friends_screen/sections/sent_requests_sections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'sections/user_search_section.dart';

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
                UserSearchSection(),
                ReceivedInvitesSection(),
                SentRequestsSection(),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
