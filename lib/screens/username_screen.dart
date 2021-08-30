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
  String nickname = '';
  bool loading = false;
  late TextEditingController _controller;

  Function setUsername = (nickname) async {
    await API.setUsername(nickname);
  };

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
                onSubmitted: (value) async {
                  setState(() {
                    loading = true;
                  });

                  await API.setUsername(nickname.toUpperCase());
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
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
                  setState(() {
                    nickname = value;
                  });
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
            if (!loading)
              TextButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    try {
                      await setUsername(nickname);
                      print('nome configurado');
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false);
                    } catch (error) {
                      setState(() {
                        loading = false;
                      });
                      final snackBar =
                          SnackBar(content: Text('Falha ao criar usuário'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text('Continuar')),
            if (loading) CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
