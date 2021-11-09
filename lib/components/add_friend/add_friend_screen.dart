import 'package:aguinha/components/add_friend/sections/send_request_modal.dart';
import 'package:aguinha/models/aguinha_user.dart';
import 'package:aguinha/services/api.dart';
import 'package:aguinha/shared/common.dart';
import 'package:aguinha/components/friends_requests/friends_requests_screen.dart';
import 'package:aguinha/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({this.username});
  static String id = 'add_friend_screen';
  final String? username;

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  String? username;
  AguinhaUser? friend;
  bool loading = false;

  void validateInput() {
    if (username == null || username!.isEmpty)
      throw 'insira um nome de usuário válido';
  }

  Future<void> search() async {
    try {
      validateInput();
      setState(() {
        loading = true;
        username = username!.replaceAll(' ', '');
        username = username!.toUpperCase();
      });

      friend = await API.getUserByUsername(username!);
      if (friend != null) {
        final sendRequest = await showModalBottomSheet(
            backgroundColor: kPrimaryColor,
            context: context,
            builder: (context) {
              return SendRequestModal(friend!);
            });

        if (sendRequest != null && sendRequest) {
          await API.sendFriendshipRequest(friend!);
          final snackBar = SnackBar(
              action: SnackBarAction(
                label: AppLocalizations.of(context)!.goToRequests,
                onPressed: () {
                  Navigator.pushNamed(context, FriendsRequestsScreen.id);
                },
              ),
              content: Text(AppLocalizations.of(context)!.requestSent));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            loading = false;
            username = null;
          });
        } else
          setState(() {
            loading = false;
            username = null;
          });
      }
    } catch (error) {
      final snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    if (widget.username != null) {
      print(widget.username);
      setState(() {
        username = widget.username;
        search();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addFriend),
        elevation: 0,
        backgroundColor: kPrimaryColor,
        shape: Border.all(width: 0, color: kPrimaryColor),
      ),
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/nav_background.svg',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topLeft,
          ),
          if (!loading) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.typeYourFriendsUsername,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  TextField(
                    cursorColor: kPrimaryColor,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor)),
                        hintStyle: TextStyle(color: kSecondaryColor),
                        helperText: AppLocalizations.of(context)!
                            .thisUsernameCanBeFoundAtHomeScreen,
                        hintText:
                            AppLocalizations.of(context)!.usernameExample),
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      search();
                    },
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: kDefaultPadding,
              child: TextButton(
                onPressed: () async {
                  await search();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 4,
                      vertical: kDefaultPadding),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: kPrimaryColor)),
                  child: Text(
                    AppLocalizations.of(context)!.search,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ] else
            Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
