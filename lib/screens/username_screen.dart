import 'package:aguinha/api.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/friends_screen.dart';
import 'package:aguinha/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({Key? key}) : super(key: key);

  static String id = 'username_screen';

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  String username = '';
  bool loading = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Function setUsername = (username) async {
      print(username.isNotEmpty);
      print(username);

      await API.setUsername(username.toUpperCase());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Insira um nome de usuário',
              style: TextStyle(fontSize: kBigFontSize),
            ),
            Text(
                'O nome escolhido será utilizado nas buscas e exibido para seus amigos'),
            Container(
              color: kPrimaryColor,
              child: TextField(
                onSubmitted: (value) {
                  setUsername(username);
                },
                controller: _controller,
                onChanged: (value) {
                  // username = value.replaceAll(new RegExp(r"\s+"), "");
                  // username = username.replaceAll(new RegExp(r"[^\s\w]"), "");
                  // username = username.toUpperCase();
                  // setState(() {
                  //   _controller.text = username;
                  //   _controller.selection = TextSelection.fromPosition(
                  //       TextPosition(offset: _controller.text.length));
                  // });
                  username = value;
                },
                // enabled: !loading,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                textCapitalization: TextCapitalization.characters,
                style:
                    TextStyle(color: Colors.white, fontSize: kMediumFontSize),
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                    fillColor: Colors.white),
              ),
            ),
            TextButton(
                onPressed: () async {
                  setUsername(username);
                },
                child: Text('Continuar'))
          ],
        ),
      ),
    );
  }
}
