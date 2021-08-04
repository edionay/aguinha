import 'package:aguinha/constants.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class RequestedInvitationTile extends StatelessWidget {
  RequestedInvitationTile(this.username, this.invitationID);

  final String username;
  final String invitationID;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final splittedUsername = username.split('#');
        showModalBottomSheet(
          context: context,
          builder: (_) => Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Aceitar solicitação de amizade?'),
                SizedBox(
                  height: kDefaultPadding * 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      splittedUsername[0],
                      style: TextStyle(
                          fontSize: 40,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('#${splittedUsername[1]}',
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
                        HttpsCallable callable = FirebaseFunctions.instance
                            .httpsCallable('acceptFriendRequest');
                        final response =
                            await callable.call({'username': username});
                        if (response.data) {
                          final snackBar = SnackBar(
                              content: Text(
                                  'Agora você e ${splittedUsername[0]} são amigos!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                      child: Text('Sim'),
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    TextButton(
                      onPressed: () async {
                        HttpsCallable callable = FirebaseFunctions.instance
                            .httpsCallable('deleteFriendRequest');
                        final response =
                            await callable.call({'username': username});
                        if (response.data) {
                          final snackBar =
                              SnackBar(content: Text('Solicitação removida!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        }
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
      },
      child: Card(
        margin: EdgeInsets.only(bottom: kDefaultPadding / 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        color: kPrimaryColor,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding * 2),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                username,
                style:
                    TextStyle(color: Colors.white, fontSize: kMediumFontSize),
              ),
              Icon(
                Icons.more_vert,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
