import 'package:aguinha/components/section_title.dart';
import 'package:aguinha/screens/add_friend_screen.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class UserSearchSection extends StatefulWidget {
  @override
  _UserSearchSectionState createState() => _UserSearchSectionState();
}

class _UserSearchSectionState extends State<UserSearchSection> {
  bool loading = false;
  String? username;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('Convite por nome de usuário'),
        Container(
          padding: EdgeInsets.all(kDefaultPadding),
          color: kPrimaryColor,
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
                enabled: !loading,
                textCapitalization: TextCapitalization.characters,
                style:
                    TextStyle(color: Colors.white, fontSize: kMediumFontSize),
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final response = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddUserScreen(username: username)));
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: kBigIconSize,
                      ),
                    ),
                    hintText: 'EXEMPLO#1212',
                    fillColor: Colors.white),
              ),
              if (loading) LinearProgressIndicator()
            ],
          ),
        ),
      ],
    );
  }
}
