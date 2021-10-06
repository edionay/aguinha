import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/api.dart';
import 'package:aguinha/common.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/friends_screen.dart';
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
    print(username);
    if (username == null) throw 'insira um nome de usuário válido';
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
      final sendRequest = await showModalBottomSheet(
          backgroundColor: kPrimaryColor,
          context: context,
          builder: (context) {
            return SendRequestModal(friend!);
          });
      if (sendRequest != null && sendRequest) {
        await API.sendFriendshipRequest(friend!);
        setState(() {
          loading = false;
          username = null;
          friend = null;
        });
        final snackBar = SnackBar(
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.goToRequests,
              onPressed: () {
                Navigator.pushNamed(context, FriendsScreen.id);
              },
            ),
            content: Text(AppLocalizations.of(context)!.requestSent));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else
        setState(() {
          loading = false;
          username = null;
          friend = null;
        });
    } catch (error) {
      setState(() {
        loading = false;
      });
      final snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(error.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.username != null) {
      print(widget.username);
      setState(() {
        username = widget.username;
        search();
      });
    }
    print('url');
    print(Uri.base.path);
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
      body: Column(
        children: [
          SvgPicture.asset(
            'assets/nav_background.svg',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topLeft,
          ),
          Center(
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  Expanded(child: Center(child: CircularProgressIndicator()))
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .typeYourFriendsUsername,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: kDefaultPadding,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .thisUsernameCanBeFoundAtHomeScreen,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kPrimaryColor,
                              ),
                            ),
                            SizedBox(
                              height: kDefaultPadding,
                            ),
                            TextField(
                              autofocus: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .usernameExample),
                              textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) async {},
                              onChanged: (value) {
                                setState(() {
                                  username = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: kDefaultPadding * 2),
                        child: TextButton(
                          onPressed: () async {
                            validateInput();
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SendRequestModal extends StatelessWidget {
  const SendRequestModal(this.friend);

  final AguinhaUser friend;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'enviar solicitação de amizade para',
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
                    'não',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        )
      ],
    );
  }
}

// class AddUserScreen extends StatefulWidget {
//   // const AddUserScreen({required this.username});
//   //
//   // final username;
//
//   static String id = 'add_friend_screen';
//
//   @override
//   _AddUserScreenState createState() => _AddUserScreenState();
// }
//
// class _AddUserScreenState extends State<AddUserScreen> {
//   bool loading = true;
//   String username = '';
//   AguinhaUser? friend;
//   final _controller = TextEditingController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     API.getUserByUsername(username).then((user) {
//       setState(() {
//         loading = false;
//         friend = user;
//       });
//     }).catchError((error) {
//       setState(() {
//         loading = false;
//         _controller.text = username;
//         username = username;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Adicionar amigo'),
//         ),
//         body: Column(
//           children: [
//             if (loading)
//               Center(child: CircularProgressIndicator())
//             else if (friend == null)
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'insira o nome de usuário do seu amigo',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 20, color: kPrimaryColor),
//                   ),
//                   TextField(
//                     controller: _controller,
//                     onChanged: (value) {
//                       setState(() {
//                         username = value;
//                       });
//                     },
//                   ),
//                   ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           loading = true;
//                         });
//                         API.getUserByUsername(username).then((user) {
//                           setState(() {
//                             friend = user;
//                             loading = false;
//                           });
//                         }).catchError((error) {
//                           setState(() {
//                             loading = false;
//                           });
//                           final snackBar =
//                               SnackBar(content: Text('Usuário inexistente'));
//                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                         });
//                       },
//                       child: Text('Buscar'))
//                 ],
//               )
//             else if (friend != null)
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Deseja enviar uma solicitação de amizade para'),
//                   SizedBox(
//                     height: kDefaultPadding * 2,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         friend!.nickname,
//                         style: TextStyle(
//                             fontSize: 40,
//                             color: kPrimaryColor,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Text('#${friend!.suffix}',
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                               fontWeight: FontWeight.normal,
//                               fontSize: 24,
//                               color: Colors.grey)),
//                     ],
//                   ),
//                   SizedBox(
//                     height: kDefaultPadding,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () async {
//                           setState(() {
//                             loading = true;
//                           });
//                           await API.sendFriendshipRequest(friend!);
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(primary: kPrimaryColor),
//                         child: Text('Sim'),
//                       ),
//                       SizedBox(
//                         width: kDefaultPadding,
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           setState(() {
//                             friend = null;
//                           });
//                         },
//                         child: Text(
//                           'Não',
//                           style: TextStyle(color: kPrimaryColor),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               )
//           ],
//         ));
//   }
// }
