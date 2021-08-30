import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/api.dart';
import 'package:aguinha/constants.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({required this.username});

  final username;

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  bool loading = true;
  String? username;
  AguinhaUser? friend;
  final _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    API.getUserByUsername(widget.username).then((user) {
      setState(() {
        loading = false;
        friend = user;
      });
    }).catchError((error) {
      setState(() {
        loading = false;
        _controller.text = widget.username;
        username = widget.username;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Adicionar amigo'),
        ),
        body: Column(
          children: [
            if (loading)
              Center(child: CircularProgressIndicator())
            else if (friend == null)
              Column(
                children: [
                  TextField(
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        if (username != null) {
                          API.getUserByUsername(username!).then((user) {
                            setState(() {
                              friend = user;
                              loading = false;
                            });
                          }).catchError((error) {
                            setState(() {
                              loading = false;
                            });
                            final snackBar =
                                SnackBar(content: Text('Usuário inexistente'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      },
                      child: Text('Buscar'))
                ],
              )
            else if (friend != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Deseja enviar uma solicitação de amizade para'),
                  SizedBox(
                    height: kDefaultPadding * 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        friend!.nickname,
                        style: TextStyle(
                            fontSize: 40,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text('#${friend!.suffix}',
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
                          setState(() {
                            loading = true;
                          });
                          await API.sendFriendshipRequest(friend!);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                        child: Text('Sim'),
                      ),
                      SizedBox(
                        width: kDefaultPadding,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            friend = null;
                          });
                        },
                        child: Text(
                          'Não',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ],
                  )
                ],
              )
          ],
        ));
  }
}
