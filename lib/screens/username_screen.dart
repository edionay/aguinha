import 'package:aguinha/api.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/friends_screen.dart';
import 'package:aguinha/screens/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aguinha/common.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({Key? key}) : super(key: key);

  static String id = 'username_screen';

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  late String nickname;
  bool loading = false;
  late TextEditingController _controller;

  Function setUsername = (String nickname) async {
    print(nickname);
    // await API.setUsername(nickname);
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
        child: Container(
          color: kPrimaryColor,
          child: Stack(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/main_background.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.setYourUsername,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding * 2),
                    child: Text(
                      AppLocalizations.of(context)!.setUsernameTip,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFB0D9EF)),
                    ),
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      textAlign: TextAlign.center,
                      autofocus: true,
                      // onSubmitted: (value) async {
                      //   setState(() {
                      //     loading = true;
                      //   });
                      //
                      //   await API.setUsername(nickname.toUpperCase());
                      //   Navigator.pushAndRemoveUntil(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => HomeScreen()),
                      //       (route) => false);
                      // },
                      onChanged: (value) {
                        nickname = value;
                      },
                      controller: _controller,
                      enabled: !loading,
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(
                          color: kPrimaryColor, fontSize: kMediumFontSize),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white60),
                          border: InputBorder.none,
                          fillColor: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  if (loading) CircularProgressIndicator()
                ],
              ),
              if (!loading)
                Positioned(
                  bottom: 20,
                  right: 0.0,
                  left: 0.0,
                  child: TextButton(
                    onPressed: () async {
                      // setState(() {
                      //   loading = true;
                      // });
                      try {
                        print(nickname.length);
                        if (nickname.length < 3) {
                          final snackBar = SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .shortUsernameInfo));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          if (nickname.length > 10) {
                            nickname = nickname.substring(0, 10);
                          }
                          nickname =
                              nickname.replaceAll(new RegExp(r"\s+"), "");
                          nickname =
                              nickname.replaceAll(new RegExp(r"[^\s\w]"), "");
                          nickname = nickname.toUpperCase();
                          nickname = nickname.trim();
                          final response = await showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  color: kPrimaryColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .chosenUsernameInfo,
                                        style: kModalTitleStyle,
                                      ),
                                      SizedBox(
                                        height: kDefaultPadding * 4,
                                      ),
                                      Text(
                                        nickname,
                                        style: kModalMainInfoStyle,
                                      ),
                                      SizedBox(
                                        height: kDefaultPadding * 4,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        kDefaultPadding * 4,
                                                    vertical: kDefaultPadding),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    border: Border.all(
                                                        color: Colors.white)),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .modify,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      kDefaultPadding * 4,
                                                  vertical: kDefaultPadding),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  border: Border.all(
                                                      color: kPrimaryColor)),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .continueButton,
                                                style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                          if (response != null) {
                            print(response);
                            if (!response) {
                              print('aqui');
                              _controller.text = nickname;
                            } else {
                              setState(() {
                                loading = true;
                              });
                              try {
                                await API.setUsername(nickname);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                    (route) => false);
                              } catch (error) {
                                setState(() {
                                  loading = false;
                                });
                                final snackBar = SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .unknownError));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          }
                        }

                        // await setUsername(nickname);
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => HomeScreen()),
                        //     (route) => false);
                      } catch (error) {
                        setState(() {
                          loading = false;
                        });
                        final snackBar =
                            SnackBar(content: Text(error.toString()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
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
                        AppLocalizations.of(context)!.continueButton,
                        style: TextStyle(
                            color: kPrimaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
